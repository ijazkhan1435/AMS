using ET_AMS_API;
using ET_AMS_API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Threading.Tasks;

[ApiController]
[Route("api/[controller]")]
public class LocationController : ControllerBase
{
    private readonly IConfiguration _config;
    private readonly AMS_API_Dbcontext _dbcontext;
    private Helper hp = new Helper();

    public LocationController(IConfiguration configuration, AMS_API_Dbcontext dbcontext)
    {
        _config = configuration;
        _dbcontext = dbcontext;
    }

    [HttpPost]
    public async Task<ActionResult<IEnumerable<Location>>> Post([FromBody] LocationFilterRequest request)
    {
        if (request == null || request.SiteID <= 0)
        {
            return BadRequest("Invalid request");
        }

        var results = new List<Location>();
        string connectionString = hp.connectionString; // Ensure this is properly set

        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                await conn.OpenAsync();

                string query = @"
                SELECT 
                    L.LocationID AS LocationID,
                    L.Description AS LocationDescription,
                    L.SiteID,
                    L.isActive AS LocationIsActive,
                    L.CreatedBy AS LocationCreatedBy,
                    L.CreateTimeStamp AS LocationCreateTimeStamp,
                    A.AssetID AS AssetID,
                    A.AssetTagID,
                    A.Description AS AssetDescription,
                    CAST(A.Cost AS DECIMAL(18, 2)) AS Cost,
                    A.Image,
                    A.IsDepreciation,
                    A.CreatedBy AS AssetCreatedBy,
                    A.CreateTimeStamp AS AssetCreateTimeStamp,
                    A.CategoryID AS AssetCategoryID,
                    H.AssetHistoryID AS AssetHistoryID,
                    H.Status as StatusHistory,
                    H.EmployeeID,
                    H.CreateTimeStamp,
                    H.Remarks,
                    H.Status
                FROM 
                    [AMS].[dbo].[AssetHistory] H
                INNER JOIN 
                    [AMS].[dbo].[AssetsM] A ON H.AssetID = A.AssetID
                INNER JOIN 
                    [AMS].[dbo].[Location] L ON L.LocationID = H.LocationID
                WHERE 
                    L.LocationID = @LocationID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@LocationID", request.SiteID);

                    using (SqlDataReader reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            try
                            {
                                results.Add(new Location
                                {
                                    LocationID = reader.IsDBNull(0) ? default : reader.GetInt32(0),
                                    LocationDescription = reader.IsDBNull(1) ? null : reader.GetString(1),
                                    SiteID = reader.IsDBNull(2) ? default : reader.GetInt32(2),
                                    LocationIsActive = reader.IsDBNull(3) ? default : reader.GetBoolean(3),
                                    LocationCreatedBy = reader.IsDBNull(4) ? default : reader.GetInt32(4),
                                    LocationCreateTimeStamp = reader.IsDBNull(5) ? default : reader.GetDateTime(5),
                                    AssetID = reader.IsDBNull(6) ? default : reader.GetInt32(6),
                                    AssetTagID = reader.IsDBNull(7) ? null : reader.GetString(7),
                                    AssetDescription = reader.IsDBNull(8) ? null : reader.GetString(8),
                                    Cost = reader.IsDBNull(9) ? default : reader.GetDecimal(9), // Correct decimal type handling
                                    Image = reader.IsDBNull(10) ? null : reader.GetString(10),
                                    IsDepreciation = reader.IsDBNull(11) ? default : reader.GetBoolean(11),
                                    AssetCreatedBy = reader.IsDBNull(12) ? default : reader.GetInt32(12),
                                    AssetCreateTimeStamp = reader.IsDBNull(13) ? default : reader.GetDateTime(13),
                                    AssetCategoryID = reader.IsDBNull(14) ? default : reader.GetInt32(14),
                                    AssetHistoryID = reader.IsDBNull(15) ? default : reader.GetInt32(15),
                                    StatusHistory = reader.IsDBNull(16) ? null : reader.GetString(16),
                                    EmployeeID = reader.IsDBNull(17) ? default : reader.GetInt32(17)
                                });
                            }
                            catch (InvalidCastException ex)
                            {
                                // Log detailed information about the exception
                                for (int i = 0; i < reader.FieldCount; i++)
                                {
                                    Console.WriteLine($"Column {i}: {reader.GetName(i)}, Value: {reader[i]}");
                                }
                                throw; // Re-throw the exception after logging
                            }
                        }
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
    [HttpGet]
    [Route("ImportAllAssets")]
    public async Task<ActionResult<IEnumerable<Location>>> ImportAllAssets()
    {
        var results = new List<Location>();
        string connectionString = hp.connectionString; // Ensure this is properly set

        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                await conn.OpenAsync();

                string query = @"
            SELECT 
                L.LocationID AS LocationID,                    -- Index 0
                L.Description AS LocationDescription,          -- Index 1 (string)
                L.SiteID,                                      -- Index 2
                L.isActive AS LocationIsActive,                -- Index 3
                L.CreatedBy AS LocationCreatedBy,              -- Index 4
                L.CreateTimeStamp AS LocationCreateTimeStamp,  -- Index 5 (DateTime)
                A.AssetID AS AssetID,                          -- Index 6
                A.AssetTagID,                                  -- Index 7 (string)
                A.Description AS AssetDescription,            -- Index 8 (string)
                CAST(A.Cost AS DECIMAL(18, 2)) AS Cost,        -- Index 9 (decimal)
                A.Image,                                       -- Index 10 (string)
                A.IsDepreciation,                              -- Index 11
                A.CreatedBy AS AssetCreatedBy,                 -- Index 12
                A.CreateTimeStamp AS AssetCreateTimeStamp,     -- Index 13 (DateTime)
                A.CategoryID AS AssetCategoryID,               -- Index 14
                H.AssetHistoryID AS AssetHistoryID,            -- Index 15
                H.Status as StatusHistory,                     -- Index 16 (string)
                H.EmployeeID,                                  -- Index 17
                H.CreateTimeStamp,                             -- Index 18 (DateTime)
                H.Remarks,                                     -- Index 19 (string)
                C.Description as CategoryDescription,          -- Index 20 (string)
                E.[First Name] as EmployeeName,                -- Index 21 (string)
                S.Description as SiteDescription               -- Index 22 (string)
            FROM 
                [AMS].[dbo].[AssetHistory] H
            LEFT JOIN 
                [AMS].[dbo].[AssetsM] A ON h.AssetID = A.AssetID
            LEFT JOIN 
                [AMS].[dbo].[Location] L ON L.LocationID = H.LocationID
            LEFT JOIN 
                [AMS].[dbo].[Category] C ON C.CategoryID = A.CategoryID
            LEFT JOIN 
                [AMS].[dbo].[Employee] E ON E.EmployeeID = H.EmployeeID
            LEFT JOIN 
                [AMS].[dbo].[Site] S ON S.SiteID = L.SiteID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataReader reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            results.Add(new Location
                            {
                                LocationID = reader.IsDBNull(0) ? default : reader.GetInt32(0),
                                LocationDescription = reader.IsDBNull(1) ? null : reader.GetString(1),
                                SiteID = reader.IsDBNull(2) ? default : reader.GetInt32(2),
                                LocationIsActive = reader.IsDBNull(3) ? default : reader.GetBoolean(3),
                                LocationCreatedBy = reader.IsDBNull(4) ? default : reader.GetInt32(4),
                                LocationCreateTimeStamp = reader.IsDBNull(5) ? default : reader.GetDateTime(5),
                                AssetID = reader.IsDBNull(6) ? default : reader.GetInt32(6),
                                AssetTagID = reader.IsDBNull(7) ? null : reader.GetString(7),
                                AssetDescription = reader.IsDBNull(8) ? null : reader.GetString(8),
                                Cost = reader.IsDBNull(9) ? default : reader.GetDecimal(9),
                                Image = reader.IsDBNull(10) ? null : reader.GetString(10),
                                IsDepreciation = reader.IsDBNull(11) ? default : reader.GetBoolean(11),
                                AssetCreatedBy = reader.IsDBNull(12) ? default : reader.GetInt32(12),
                                AssetCreateTimeStamp = reader.IsDBNull(13) ? default : reader.GetDateTime(13),
                                AssetCategoryID = reader.IsDBNull(14) ? default : reader.GetInt32(14),
                                AssetHistoryID = reader.IsDBNull(15) ? default : reader.GetInt32(15),
                                StatusHistory = reader.IsDBNull(16) ? null : reader.GetString(16),
                                EmployeeID = reader.IsDBNull(17) ? default : reader.GetInt32(17),
                                AssetHistoryCreateTimeStamp = reader.IsDBNull(18) ? default : reader.GetDateTime(18),
                                Remarks = reader.IsDBNull(19) ? null : reader.GetString(19),
                                CategoryDescription = reader.IsDBNull(20) ? null : reader.GetString(20),
                                EmployeeName = reader.IsDBNull(21) ? null : reader.GetString(21),
                                SiteDescription = reader.IsDBNull(22) ? null : reader.GetString(22)
                            });
                        }
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




    [HttpGet]
    [Route("ImportAllLocations")]
    public async Task<ActionResult<IEnumerable<Locations>>> ImportAllLocations()
    {
        var results = new List<Locations>();
        string connectionString = hp.connectionString; // Ensure this is properly set

        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                await conn.OpenAsync();

                string query = @"
            SELECT 
                L.LocationID AS LocationID,
                L.Description AS LocationDescription,
                L.SiteID,
                S.Description AS SiteDescription
            FROM
                [AMS].[dbo].[Location] L
            INNER JOIN
                [AMS].[dbo].[Site] S
            ON
                L.SiteID = S.SiteID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataReader reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            try
                            {
                                results.Add(new Locations
                                {
                                    LocationID = reader.IsDBNull(0) ? default : reader.GetInt32(0),
                                    LocationDescription = reader.IsDBNull(1) ? null : reader.GetString(1),
                                    SiteID = reader.IsDBNull(2) ? default : reader.GetInt32(2),
                                    SiteDescription = reader.IsDBNull(3) ? null : reader.GetString(3)
                                });
                            }
                            catch (InvalidCastException ex)
                            {
                                // Log detailed information about the exception
                                for (int i = 0; i < reader.FieldCount; i++)
                                {
                                    Console.WriteLine($"Column {i}: {reader.GetName(i)}, Value: {reader[i]}");
                                }
                                throw; // Re-throw the exception after logging
                            }
                        }
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



    [HttpPost]
    [Route("ExportAuditData")]
    public async Task<ActionResult> ExportAuditData([FromBody] AuditReportDetail newAuditReportDetail)
    {
        string connectionString = hp.connectionString; // Ensure this is properly set

        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                await conn.OpenAsync();

                string query = @"
                INSERT INTO [AMS].[dbo].[AuditHistory] 
                (AssetId, AuditStatus, CreatedBy, AuditDateTime) 
                VALUES (@AssetId, @AuditStatus, @CreatedBy, @AuditDateTime)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                  
                    cmd.Parameters.AddWithValue("@AssetId", newAuditReportDetail.AssetId);
                    cmd.Parameters.AddWithValue("@AuditStatus", newAuditReportDetail.AuditStatus);
                    cmd.Parameters.AddWithValue("@CreatedBy", newAuditReportDetail.CreatedBy);
                    cmd.Parameters.AddWithValue("@AuditDateTime", DateTime.Now); // Set the current date and time

                    await cmd.ExecuteNonQueryAsync();
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

        return Ok("Audit report detail inserted successfully.");
    }
    [HttpPost]
    [Route("CraeteAsset")]
    public async Task<ActionResult> SaveAsset([FromBody] CraeteAsset assetInput)
    {
        string connectionString = hp.connectionString; // Ensure this is properly set

        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                await conn.OpenAsync();

                using (SqlTransaction transaction = conn.BeginTransaction())
                {
                    try
                    {
                        // Insert data into the AssetsM table
                        string assetInsertQuery = @"
                        INSERT INTO [AMS].[dbo].[AssetsM] 
                        (AssetTagId, Cost, Image, IsDepreciation, Description, CategoryID)
                        VALUES (@AssetTagID, @Cost, @Image, @IsDepreciation, @Description, @CategoryID);
                        SELECT SCOPE_IDENTITY();"; // Get the inserted AssetID

                        SqlCommand assetCmd = new SqlCommand(assetInsertQuery, conn, transaction);
                        assetCmd.Parameters.AddWithValue("@AssetTagID", assetInput.AssetTagID);
                        assetCmd.Parameters.AddWithValue("@Cost", assetInput.Cost);
                        assetCmd.Parameters.AddWithValue("@Image", (object)assetInput.Image ?? DBNull.Value);
                        assetCmd.Parameters.AddWithValue("@IsDepreciation", assetInput.IsDepreciation);
                        assetCmd.Parameters.AddWithValue("@Description", assetInput.Description);
                        assetCmd.Parameters.AddWithValue("@CategoryID", assetInput.CategoryID);

                        int assetID = Convert.ToInt32(await assetCmd.ExecuteScalarAsync());

                        // Insert data into the AssetHistory table
                        string historyInsertQuery = @"
                        INSERT INTO [AMS].[dbo].[AssetHistory] 
                        (AssetID, CreatedBy, Status, Remarks, CreateTimeStamp, LocationID, EmployeeID)
                        VALUES (@AssetID, @CreatedBy, @Status, @Remarks, @CreateTimeStamp, @LocationID, @EmployeeID);";

                        SqlCommand historyCmd = new SqlCommand(historyInsertQuery, conn, transaction);
                        historyCmd.Parameters.AddWithValue("@AssetID", assetID);
                        historyCmd.Parameters.AddWithValue("@CreatedBy", assetInput.CreatedBy);
                        historyCmd.Parameters.AddWithValue("@Status", assetInput.Status);
                        historyCmd.Parameters.AddWithValue("@Remarks", (object)assetInput.Remarks ?? DBNull.Value);
                        historyCmd.Parameters.AddWithValue("@CreateTimeStamp", (object)assetInput.CreateTimeStamp ?? DBNull.Value);
                        historyCmd.Parameters.AddWithValue("@LocationID", assetInput.LocationID);
                        historyCmd.Parameters.AddWithValue("@EmployeeID", assetInput.EmployeeID);

                        await historyCmd.ExecuteNonQueryAsync();

                        // Commit the transaction
                        transaction.Commit();
                    }
                    catch (Exception ex)
                    {
                        // Rollback the transaction if something goes wrong
                        transaction.Rollback();
                        return StatusCode(500, "Internal server error: " + ex.Message);
                    }
                }
            }
        }
        catch (SqlException ex)
        {
            return StatusCode(500, "Database error: " + ex.Message);
        }
        catch (Exception ex)
        {
            return StatusCode(500, "Internal server error: " + ex.Message);
        }

        return Ok("Asset saved successfully.");
    }

    [HttpDelete]
[Route("DeleteAsset")]
public async Task<ActionResult> DeleteAsset(int assetId)
{
    string connectionString = hp.connectionString; // Ensure this is properly set

    try
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            await conn.OpenAsync();

            using (SqlTransaction transaction = conn.BeginTransaction())
            {
                try
                {
                    // Delete data from AssetHistory table
                    string historyDeleteQuery = @"
                        DELETE FROM [AMS].[dbo].[AssetHistory]
                        WHERE AssetID = @AssetID;";

                    SqlCommand historyCmd = new SqlCommand(historyDeleteQuery, conn, transaction);
                    historyCmd.Parameters.AddWithValue("@AssetID", assetId);
                    await historyCmd.ExecuteNonQueryAsync();

                    // Delete data from AssetsM table
                    string assetDeleteQuery = @"
                        DELETE FROM [AMS].[dbo].[AssetsM]
                        WHERE AssetID = @AssetID;";

                    SqlCommand assetCmd = new SqlCommand(assetDeleteQuery, conn, transaction);
                    assetCmd.Parameters.AddWithValue("@AssetID", assetId);
                    await assetCmd.ExecuteNonQueryAsync();

                    // Commit the transaction
                    transaction.Commit();
                }
                catch (Exception ex)
                {
                    // Rollback the transaction if something goes wrong
                    transaction.Rollback();
                    return StatusCode(500, "Internal server error: " + ex.Message);
                }
            }
        }
    }
    catch (SqlException ex)
    {
        return StatusCode(500, "Database error: " + ex.Message);
    }
    catch (Exception ex)
    {
        return StatusCode(500, "Internal server error: " + ex.Message);
    }

    return Ok("Asset deleted successfully.");
}

}