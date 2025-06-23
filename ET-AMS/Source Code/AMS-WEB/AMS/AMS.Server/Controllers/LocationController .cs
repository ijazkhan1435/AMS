using AMS.Server.Models;
using ET_AMS_API;
using ET_AMS_API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
//using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;

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
                    [AssetHistory] H
                INNER JOIN 
                    [AssetsM] A ON H.AssetID = A.AssetID
                INNER JOIN 
                    [Location] L ON L.LocationID = H.LocationID
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
    public async Task<ActionResult<IEnumerable<AssetWithHistory>>> GetAssetsWithHistory()
    {
        var results = new List<AssetWithHistory>();
        string connectionString = hp.connectionString; // Ensure this is properly set

        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                await conn.OpenAsync();

                string query = @"
            SELECT  
                A.AssetTagId,
                A.Description AS AssetDescription,
                C.Description AS CategoryDescription,
                A.CreatedBy,
                A.CreateTimeStamp,
                A.Image,
                A.isActive,
                A.Cost,
                H.Status AS AssetHistoryStatus,
                A.LocationID,
                H.EmployeeID,
                S.Description AS StatusDescription,
                A.SiteID,
                Ss.Description AS SiteDescription,
                L.Description AS LocationDescription
            FROM 
                AssetsM AS A
            inner JOIN 
                Status AS S ON A.StatusID = S.StatusID
            inner JOIN 
                AssetHistory AS H ON H.AssetID = A.AssetID
            inner JOIN 
                Category AS C ON C.CategoryID = A.CategoryID
            inner JOIN 
                Location AS L ON L.LocationID = A.LocationID
            inner JOIN 
                Site AS Ss ON Ss.SiteID = A.SiteID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataReader reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            results.Add(new AssetWithHistory
                            {
                                AssetTagId = reader.IsDBNull(0) ? null : reader.GetString(0),
                                AssetDescription = reader.IsDBNull(1) ? null : reader.GetString(1),
                                CategoryDescription = reader.IsDBNull(2) ? null : reader.GetString(2),
                                CreatedBy = reader.IsDBNull(3) ? default : reader.GetInt32(3),
                                CreateTimeStamp = reader.IsDBNull(4) ? default : reader.GetDateTime(4),
                                Image = reader.IsDBNull(5) ? null : reader.GetString(5),
                                IsActive = reader.IsDBNull(6) ? default : reader.GetBoolean(6),
                                Cost = reader.IsDBNull(7) ? default : reader.GetDecimal(7),
                                AssetHistoryStatus = reader.IsDBNull(8) ? null : reader.GetString(8),
                                LocationID = reader.IsDBNull(9) ? default : reader.GetInt32(9),
                                EmployeeID = reader.IsDBNull(10) ? default : reader.GetInt32(10),
                                StatusDescription = reader.IsDBNull(11) ? null : reader.GetString(11),
                                SiteID = reader.IsDBNull(12) ? default : reader.GetInt32(12),
                                SiteDescription = reader.IsDBNull(13) ? null : reader.GetString(13),
                                LocationDescription = reader.IsDBNull(14) ? null : reader.GetString(14)
                            });
                        }
                    }
                }
            }
        }
        catch (SqlException ex)
        {
            // Log the exception and return an appropriate error response
            return StatusCode(500, "Database error: " + ex.Message);
        }
        catch (Exception ex)
        {
            // Log the exception and return an appropriate error response
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
                Location L
            INNER JOIN
                Site S
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
    [HttpGet]
    [Route("GetAllViewAssets")]
    public async Task<ActionResult<IEnumerable<ViewAssets>>> GetAllViewAssets()
    {
        var results = new List<ViewAssets>();
        string connectionString = hp.connectionString; // Ensure this is properly set

        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                await conn.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("uspGetAllViewAssets", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    using (SqlDataReader reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            try
                            {
                                results.Add(new ViewAssets
                                {
                                    LocationID = reader["LocationID"] as int? ?? default,
                                    LocationIsActive = reader["LocationIsActive"] as bool? ?? default,
                                    AssetDescription = reader["AssetDescription"] as string,
                                    Cost = reader["Cost"] as decimal? ?? default,
                                    AssetID = reader["AssetID"] as int? ?? default,
                                    AssetTagID = reader["AssetTagID"] as string,
                                    IsDepreciation = reader["IsDepreciation"] as bool? ?? default,
                                    AssetHistoryID = reader["AssetHistoryID"] as int? ?? default,
                                    StatusHistory = reader["StatusHistory"] as string,
                                    EmployeeID = reader["EmployeeID"] as int? ?? default,
                                    Remarks = reader["Remarks"] as string,
                                    EmployeeName = reader["EmployeeName"] as string,
                                    LocationDescription = reader["LocationDescription"] as string
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
    [Route("ExportAuditDetail")]
    public IActionResult InsertAuditHistory([FromQuery] string assetTagIDs, [FromQuery] string auditStatuses)
    {
        if (string.IsNullOrEmpty(assetTagIDs) || string.IsNullOrEmpty(auditStatuses))
        {
            return BadRequest("Both AssetTagIDs and AuditStatuses are required.");
        }

        try
        {
            // Split the input parameters into lists
            var assetTagIDList = assetTagIDs.Trim('[', ']').Split(',').Select(int.Parse).ToList();
            var auditStatusList = auditStatuses.Trim('[', ']').Split(',').Select(s => s.Trim('\'', ' ')).ToList();

            // Ensure both lists have the same number of entries
            if (assetTagIDList.Count != auditStatusList.Count)
            {
                return BadRequest("The number of AssetTagIDs must match the number of AuditStatuses.");
            }

            List<int> filteredAssetTagIDs = new List<int>();
            List<string> filteredAuditStatuses = new List<string>();

            string connectionString = hp.connectionString;
            int createdBy = 1; // Hardcoded value for CreatedBy

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                for (int i = 0; i < assetTagIDList.Count; i++)
                {
                    int assetTagID = assetTagIDList[i];
                    string auditStatus = auditStatusList[i];

                    // Insert each asset and status into the AuditHistory table
                    string insertQuery = @"
                    INSERT INTO AuditHistory (AssetID, AuditStatus, CreatedBy, AuditDateTime)
                    VALUES (@AssetID, @AuditStatus, @CreatedBy, GETDATE())";

                    using (SqlCommand insertCommand = new SqlCommand(insertQuery, connection))
                    {
                        insertCommand.Parameters.AddWithValue("@AssetID", assetTagID);
                        insertCommand.Parameters.AddWithValue("@AuditStatus", auditStatus);
                        insertCommand.Parameters.AddWithValue("@CreatedBy", createdBy); // Use hardcoded value for CreatedBy
                        insertCommand.ExecuteNonQuery();
                    }

                    // Add to filtered lists for response
                    filteredAssetTagIDs.Add(assetTagID);
                    filteredAuditStatuses.Add(auditStatus);
                }

                connection.Close();
            }

            // Return the results in the requested format
            var result = new
            {
                AssetTagIDs = filteredAssetTagIDs,
                AuditStatuses = filteredAuditStatuses
            };

            return Ok(result);
        }
        catch (Exception ex)
        {
            // Log the exception as needed
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
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
                        INSERT INTO [AssetsM] 
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
                        INSERT INTO [AssetHistory] 
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
                        DELETE FROM [AssetHistory]
                        WHERE AssetID = @AssetID;";

                        SqlCommand historyCmd = new SqlCommand(historyDeleteQuery, conn, transaction);
                        historyCmd.Parameters.AddWithValue("@AssetID", assetId);
                        await historyCmd.ExecuteNonQueryAsync();

                        // Delete data from AssetsM table
                        string assetDeleteQuery = @"
                        DELETE FROM [AssetsM]
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

    [HttpPost]
    [Route("UpdateAssetStatusAndLocation")]

    public IActionResult UpdateAssetStatus(string assetTagId, int statusID, int locationID)
    {
        string connectionString = hp.connectionString; // Ensure the connection string is properly set
        try
        {
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (var transaction = connection.BeginTransaction())
                {
                    // Update the asset's StatusID and LocationID based on the AssetTagId
                    var updateQuery = @"
                UPDATE AssetsM
                SET 
                    StatusID = @StatusID,
                    LocationID = @LocationID
                WHERE 
                    AssetTagId = @AssetTagId;";

                    using (var updateCommand = new SqlCommand(updateQuery, connection, transaction))
                    {
                        // Adding parameters
                        updateCommand.Parameters.AddWithValue("@StatusID", statusID);
                        updateCommand.Parameters.AddWithValue("@LocationID", locationID);
                        updateCommand.Parameters.AddWithValue("@AssetTagId", assetTagId);

                        int rowsAffected = updateCommand.ExecuteNonQuery();
                        if (rowsAffected == 0)
                        {
                            transaction.Rollback();
                            return NotFound("No asset found with the given AssetTagId.");
                        }
                    }

                    // Retrieve the updated asset details after the update
                    var selectQuery = @"
                SELECT 
                    A.AssetID,
                    A.AssetTagId,
                    S.Description AS UpdatedStatus,
                    A.LocationID -- Include the updated LocationID
                FROM 
                    AssetsM A
                LEFT JOIN 
                    Status S ON A.StatusID = S.StatusID
                WHERE 
                    A.AssetTagId = @AssetTagId;";

                    using (var selectCommand = new SqlCommand(selectQuery, connection, transaction))
                    {
                        selectCommand.Parameters.AddWithValue("@AssetTagId", assetTagId);

                        var result = new List<object>();
                        using (var reader = selectCommand.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                result.Add(new
                                {
                                    AssetID = reader["AssetID"],
                                    AssetTagId = reader["AssetTagId"],
                                    UpdatedStatus = reader["UpdatedStatus"],
                                    UpdatedLocationID = reader["LocationID"] // Return the updated LocationID
                                });
                            }
                        }

                        if (result.Count == 0)
                        {
                            transaction.Rollback();
                            return NotFound("Asset not found after update.");
                        }

                        // Commit the transaction if everything is successful
                        transaction.Commit();
                        return Ok(result);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            // Log the error and return a 500 status with the error message
            return StatusCode(500, "Internal server error: " + ex.Message);
        }
    }
    [HttpPost]
    [Route("ExportAssets")]
    public async Task<IActionResult> ExportAssets([FromBody] List<AssetDto> assets)
    {
        if (assets == null || assets.Count == 0)
        {
            return BadRequest("Assets data is required.");
        }

        try
        {
            foreach (var asset in assets)
            {
                // Raw SQL execution using stored procedure and parameters
                await _dbcontext.Database.ExecuteSqlRawAsync(
                    "EXEC [dbo].[InsertAssetAndHistorys] @AssetTagId, @AssetDescription, @CreatedBy, @Image, @IsActive, @Cost, @LocationID, @CategoryID, @StatusID, @SiteID, @AssetHistoryStatus, @EmployeeID",
                    new SqlParameter("@AssetTagId", asset.AssetTagId),
                    new SqlParameter("@AssetDescription", asset.AssetDescription),
                    new SqlParameter("@CreatedBy", asset.CreatedBy),
                    new SqlParameter("@Image", asset.Image ?? (object)DBNull.Value), // Handle null Image
                    new SqlParameter("@IsActive", asset.IsActive),
                    new SqlParameter("@Cost", asset.Cost),
                    new SqlParameter("@LocationID", asset.LocationID),
                    new SqlParameter("@CategoryID", asset.CategoryID),
                    new SqlParameter("@StatusID", asset.StatusID),
                    new SqlParameter("@SiteID", asset.SiteID),
                    new SqlParameter("@AssetHistoryStatus", asset.AssetHistoryStatus ?? (object)DBNull.Value), // Handle null AssetHistoryStatus
                    new SqlParameter("@EmployeeID", asset.EmployeeID ?? (object)DBNull.Value) // Handle nullable EmployeeID
                );
            }

            return Ok("Assets inserted successfully.");
        }
        catch (SqlException sqlEx)
        {
            // Log the error (you could use a logging library)
            return StatusCode(500, $"Database error: {sqlEx.Message}");
        }
        catch (Exception ex)
        {
            // Log the error (you could use a logging library)
            return StatusCode(500, $"An unexpected error occurred: {ex.Message}");
        }
    }



    [HttpGet]
    [Route("GetTotalInsertAssets")]
    public async Task<IActionResult> GetTotalUniqueAssets()
    {
        try
        {
            // Execute the stored procedure using the DbSet
            var assets = await _dbcontext.UniqueAssets
                .FromSqlRaw("EXEC [dbo].[GetTotalInsertAssets]")
                .ToListAsync();

            // Check if there are any results
            if (assets == null || assets.Count == 0)
            {
                return NotFound("No unique assets found.");
            }

            // Return the results
            return Ok(assets);
        }
        catch (SqlException sqlEx)
        {
            // Log the error (you could use a logging library)
            return StatusCode(500, $"Database error: {sqlEx.Message}");
        }
        catch (Exception ex)
        {
            // Log the error (you could use a logging library)
            return StatusCode(500, $"An unexpected error occurred: {ex.Message}");
        }
    }



    //[HttpPost]
    //[Route("ExportAssets")]
    //public async Task<IActionResult> ExportAssets([FromBody] List<AssetDto> assets)
    //{
    //    if (assets == null || assets.Count == 0)
    //    {
    //        return BadRequest("Assets data is required.");
    //    }

    //    try
    //    {
    //        foreach (var asset in assets)
    //        {
    //            // Check if the AssetTagId already exists in the database
    //            var existingAsset = await AMS_API_Dbcontext.Assets
    //.AsQueryable().FirstOrDefaultAsync(a => a.AssetTagId == asset.AssetTagId);

    //            // Only insert if the AssetTagId does not already exist
    //            if (existingAsset == null)
    //            {
    //                // Raw SQL execution using stored procedure and parameters
    //                await _dbcontext.Database.ExecuteSqlRawAsync(
    //                    "EXEC [dbo].[InsertAssetAndHistory] @AssetTagId, @AssetDescription, @CreatedBy, @Image, @IsActive, @Cost, @LocationID, @CategoryID, @StatusID, @SiteID, @AssetHistoryStatus, @EmployeeID",
    //                    new SqlParameter("@AssetTagId", asset.AssetTagId),
    //                    new SqlParameter("@AssetDescription", asset.AssetDescription),
    //                    new SqlParameter("@CreatedBy", asset.CreatedBy),
    //                    new SqlParameter("@Image", asset.Image ?? (object)DBNull.Value), // Handle null Image
    //                    new SqlParameter("@IsActive", asset.IsActive),
    //                    new SqlParameter("@Cost", asset.Cost),
    //                    new SqlParameter("@LocationID", asset.LocationID),
    //                    new SqlParameter("@CategoryID", asset.CategoryID),
    //                    new SqlParameter("@StatusID", asset.StatusID),
    //                    new SqlParameter("@SiteID", asset.SiteID),
    //                    new SqlParameter("@AssetHistoryStatus", asset.AssetHistoryStatus ?? (object)DBNull.Value), // Handle null AssetHistoryStatus
    //                    new SqlParameter("@EmployeeID", asset.EmployeeID ?? (object)DBNull.Value) // Handle nullable EmployeeID
    //                );
    //            }
    //        }

    //        return Ok("Assets inserted successfully.");
    //    }
    //    catch (SqlException sqlEx)
    //    {
    //        Console.WriteLine($"SQL Error: {sqlEx.Message}"); // Log SQL error
    //        return StatusCode(500, $"Database error: {sqlEx.Message}");
    //    }
    //    catch (Exception ex)
    //    {
    //        Console.WriteLine($"Error: {ex.Message}"); // Log general error
    //        return StatusCode(500, $"An unexpected error occurred: {ex.Message}");
    //    }
    //}

}


//public IActionResult UpdateAssetStatusAndLocation(string assetTagId, int statusID, int locationID)
//{
//    string connectionString = hp.connectionString;
//    try
//    {
//        using (var connection = new SqlConnection(connectionString))
//        {
//            connection.Open();

//            using (var transaction = connection.BeginTransaction())
//            {
//                // Update the asset's status and location
//                var updateQuery = @"
//                UPDATE AssetsM
//                SET 
//                    Description = (SELECT Description FROM Status WHERE StatusID = @StatusID),
//                    CategoryID = @LocationID
//                WHERE 
//                    AssetTagId = @AssetTagId;";

//                using (var updateCommand = new SqlCommand(updateQuery, connection, transaction))
//                {
//                    updateCommand.Parameters.AddWithValue("@StatusID", statusID);
//                    updateCommand.Parameters.AddWithValue("@LocationID", locationID);
//                    updateCommand.Parameters.AddWithValue("@AssetTagId", assetTagId);

//                    int rowsAffected = updateCommand.ExecuteNonQuery();
//                    if (rowsAffected == 0)
//                    {
//                        transaction.Rollback();
//                        return NotFound("No asset found with the given AssetTagId.");
//                    }
//                }

//                // Retrieve the updated asset details
//                var selectQuery = @"
//                SELECT 
//                    A.AssetID,
//                    A.AssetTagId,
//                    A.Description AS UpdatedDescription,
//                    S.Description AS UpdatedStatus,
//                    L.Description AS UpdatedLocation
//                FROM 
//                    AssetsM A
//                LEFT JOIN 
//                    Status S ON S.StatusID = @StatusID
//                LEFT JOIN 
//                    Location L ON L.LocationID = @LocationID
//                WHERE 
//                    A.AssetTagId = @AssetTagId;";

//                using (var selectCommand = new SqlCommand(selectQuery, connection, transaction))
//                {
//                    selectCommand.Parameters.AddWithValue("@StatusID", statusID);
//                    selectCommand.Parameters.AddWithValue("@LocationID", locationID);
//                    selectCommand.Parameters.AddWithValue("@AssetTagId", assetTagId);

//                    // Ensure the previous reader is closed before executing a new one
//                    var result = new List<object>();
//                    using (var reader = selectCommand.ExecuteReader())
//                    {
//                        while (reader.Read())
//                        {
//                            result.Add(new
//                            {
//                                AssetID = reader["AssetID"],
//                                AssetTagId = reader["AssetTagId"],
//                                UpdatedDescription = reader["UpdatedDescription"],
//                                UpdatedStatus = reader["UpdatedStatus"],
//                                UpdatedLocation = reader["UpdatedLocation"]
//                            });
//                        }
//                    }

//                    if (result.Count == 0)
//                    {
//                        transaction.Rollback();
//                        return NotFound("Asset not found after update.");
//                    }

//                    transaction.Commit();
//                    return Ok(result);
//                }
//            }
//        }
//    }
//    catch (Exception ex)
//    {
//        return StatusCode(500, "Internal server error: " + ex.Message);
//    }
//}
