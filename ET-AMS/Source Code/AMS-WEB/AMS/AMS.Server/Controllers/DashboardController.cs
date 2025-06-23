using Microsoft.AspNetCore.Mvc;
using ET_AMS_API.Models;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;
using AMS.Server.Models;

namespace AMS.Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DashboardController : ControllerBase // Use ControllerBase for APIs
    {
        private readonly AMS_API_Dbcontext _dbcontext;

        public DashboardController(AMS_API_Dbcontext dbcontext)
        {
            _dbcontext = dbcontext;
        }

        [HttpGet("TotalAssets")]
        public IActionResult GetTotalNumberOfAssets()
        {
            try
            {
                // Query the total number of assets in the AssetsM table
                var totalAssets = _dbcontext.AssetsM.Count(); // Ensure this matches the DbSet definition

                return Ok(new { TotalAssets = totalAssets });
            }
            catch (Exception ex)
            {
                // Log the error
                return StatusCode(500, "Internal server error: " + ex.Message);
            }
        }

        [HttpGet("TotalUsers")]
        public async Task<IActionResult> GetTotalUsers()
        {
            try
            {
                // Count the total number of users in the UserProfile table
                int totalUsers = await _dbcontext.UserProfile.CountAsync();

                return Ok(new { TotalUsers = totalUsers });
            }
            catch (Exception ex)
            {
                // Log the error or handle it as needed
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpGet("AssetCountByStatus")]
        public async Task<ActionResult<IEnumerable<AssetStatusCountModel>>> GetAssetCountByStatus()
        {
            try
            {
                // Create the SQL query to get the count of assets by status
                var result = await _dbcontext.AssetsM
                    .GroupBy(a => a.StatusID)
                    .Select(g => new AssetStatusCountModel
                    {
                        StatusDescription = _dbcontext.Status.Where(s => s.StatusID == g.Key).Select(s => s.Description).FirstOrDefault(),
                        AssetCount = g.Count()
                    }).ToListAsync();

                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpGet("AssetCountByCategory")]
        public async Task<ActionResult<IEnumerable<AssetCategoryCount>>> GetAssetCountByCategory()
        {
            try
            {
                // Group assets by CategoryID and count the assets in each category
                var result = await _dbcontext.AssetsM
                    .GroupBy(a => a.CategoryID) // Group by CategoryID
                    .Select(g => new AssetCategoryCount
                    {
                        // Fetch the category description for each CategoryID
                        CategoryDescription = _dbcontext.Category
                            .Where(c => c.CategoryID == g.Key) // Join with Category table using CategoryID
                            .Select(c => c.Description)
                            .FirstOrDefault(), // Get the category description for each CategoryID
                        AssetCount = g.Count() // Count the assets in each category group
                    })
                    .ToListAsync();

                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }



    }
}
