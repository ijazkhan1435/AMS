using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient; 
using Microsoft.EntityFrameworkCore;
using System;
using System.Threading.Tasks;
using System.Collections.Generic;
using ET_AMS_API.Models;
using ET_AMS_API;
using AMS.Server.Models;
using System.Data.Entity;
using System.Data;

namespace AMS.Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ReportsDetailPageController : ControllerBase
    {
        private readonly AMS_API_Dbcontext _dbcontext;
        private Helper hp = new Helper();

        public ReportsDetailPageController(IConfiguration configuration, AMS_API_Dbcontext dbcontext)
        {
            _dbcontext = dbcontext;
        }
        [HttpGet("GetAuditHistoryByCreateDateTime")]
        public async Task<IActionResult> GetAuditHistoryByCreateDateTime(DateTime date)
        {
            try
            {
                var createDateTimeParam = new SqlParameter("@CreateDateTime", date);

                var auditHistory = await _dbcontext.AuditHistoryDetails
                    .FromSqlRaw("EXEC uspGetAuditHistoryByCreateDateTime @CreateDateTime", createDateTimeParam)
                    .ToListAsync();

                if (auditHistory == null || !auditHistory.Any())
                {
                    return NotFound("No data found for the given CreateDateTime.");
                }

                foreach (var item in auditHistory)
                {
                    var description = item.AssetDescription ?? "No description available";
                    // Other processing
                }

                return Ok(auditHistory);
            }
            catch (Exception ex)
            {
                // Log the exception details for debugging
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        [HttpGet]
        [Route("GetAuditHistoryDetails")]

        public async Task<ActionResult<IEnumerable<Reportdetail>>> GetAuditHistorySummary()
        {
            var results = new List<Reportdetail>();
            string connectionString = hp.connectionString;  // Ensure this is set correctly

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    await conn.OpenAsync();

                    string query = @"
                SELECT 
                    CAST(CreateTimeStamp AS DATE) AS CreateDate,  -- Extracts the date part
                    CreatedBy,
                    COUNT(*) AS TotalUniqueAssets  -- Count of unique assets per date and user
                FROM dbo.AssetsM
                WHERE AssetID IS NOT NULL AND CreateTimeStamp IS NOT NULL
                GROUP BY CAST(CreateTimeStamp AS DATE), CreatedBy
                ORDER BY CreateDate, CreatedBy;";

                    // Get the DataSet
                    var dataSet = hp.GetDataset(query);
                    DataTable table = dataSet.Tables[0];

                    // Convert the DataSet to List<Reportdetail>
                    if (table != null && table.Rows.Count > 0)
                    {
                        foreach (DataRow row in table.Rows)
                        {
                            var reportDetail = new Reportdetail
                            {
                                CreateTimeStamp = row.IsNull("CreateDate") ? "" : Convert.ToDateTime(row["CreateDate"]).ToString("yyyy-MM-dd"), // Format date
                                CreatedBy = row.IsNull("CreatedBy") ? 0 : Convert.ToInt32(row["CreatedBy"]),
                                TotalUniqueAssets = row.IsNull("TotalUniqueAssets") ? 0 : Convert.ToInt32(row["TotalUniqueAssets"])
                            };

                            results.Add(reportDetail);
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                // Log exception
                return StatusCode(500, "Database error: " + ex.Message);
            }
            catch (Exception ex)
            {
                // Log exception
                return StatusCode(500, "Internal server error: " + ex.Message);
            }

            return Ok(results);
        }


        [HttpGet("GetAuditReportDetailsByDateTime")]
        public async Task<ActionResult<IEnumerable<ViewDeatils>>> GetAuditReportDetailsByDateTime([FromQuery] DateTime auditDateTime)
        {
            string connectionString = hp.connectionString;  // Replace with your actual connection string

            string str = auditDateTime.Date.ToString("yyyy-MM-dd").Split(" ")[0];


            //    var query = @"
            //SELECT 
            //    MIN(a.AuditReportDetailId) AS AuditReportDetailId,  
            //    a.AssetId, 
            //    MIN(a.AuditStatus) AS AuditStatus,
            //    MIN(e.Email) AS Email,
            //    MIN(e.[First Name]) AS FirstName,
            //    MIN(e.[Last Name]) AS LastName,
            //   L.Description as Location,
            // S.Description as SiteDescription
            //FROM 
            //    AuditHistory AS a
            //INNER JOIN 
            //    Employee AS e ON a.CreatedBy = e.CreatedBy
            //inner  join 
            // Location as L on L.CreatedBy=e.CreatedBy
            // inner join 
            // Site as S on S.CreatedBy=e.CreatedBy    
            //WHERE 
            //    a.AuditDateTime = @AuditDateTime
            //GROUP BY 
            //    a.AssetId,L.Description,S.Description;";

            var query = $@"
                                SELECT 
                            a.AssetId, 
                            MIN(e.Email) AS Email,
                            MIN(e.[First Name]) AS FirstName,
                            MIN(e.[Last Name]) AS LastName,
                            L.Description as Location,
                            S.Description as SiteDescription,
                            MIN(m.Description) AS AuditStatus,
                            a.CreateTimeStamp 
                        FROM 
                            AssetsM as a
                        INNER JOIN 
                            Employee AS e ON a.CreatedBy = e.CreatedBy
                        INNER JOIN 
                            Location as L ON L.CreatedBy = e.CreatedBy
                        INNER JOIN 
                            Site as S ON S.CreatedBy = e.CreatedBy
                        JOIN 
                            [Status] m ON m.StatusID = a.StatusID
                        WHERE 
                            CAST(a.CreateTimeStamp AS DATE) = '{str}'
                        GROUP BY 
                            a.AssetId, L.Description, S.Description, m.Description, a.CreateTimeStamp;
                        ";

            try
            {
                using var conn = new SqlConnection(connectionString);
                await conn.OpenAsync();

                using var cmd = new SqlCommand(query, conn);
                //cmd.Parameters.AddWithValue("@str", str);

                using var reader = await cmd.ExecuteReaderAsync();

                var results = new List<ViewDeatils>();
                while (await reader.ReadAsync())
                {
                    results.Add(new ViewDeatils
                    {
                        AssetID = reader.GetInt32(0),                       // AssetId
                        Email = reader.GetString(1),                        // Email
                        FirstName = reader.GetString(2),                    // FirstName
                        LastName = reader.GetString(3),                     // LastName
                        Location = reader.GetString(4),                     // Location
                        SiteDescription = reader.GetString(5),              // SiteDescription
                        AuditStatus = reader.GetString(6),                  // AuditStatus
                        CreateTimeStamp = reader.GetDateTime(7)             // CreateTimeStamp
                    });
                }


                return Ok(results);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error: {ex.Message}");
            }
        }



    }
}