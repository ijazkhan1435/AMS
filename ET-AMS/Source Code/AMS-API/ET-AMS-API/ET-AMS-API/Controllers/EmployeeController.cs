using ET_AMS_API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Net.Http;

namespace ET_AMS_API.Controllers
{



    [Route("api/[controller]")]
    [ApiController]
    public class AMS_Restapi : ControllerBase
    {
        private Helper Hp;
        private DataSet ds;

        public AMS_Restapi(IConfiguration configuration)
        {
            ds = new DataSet();
            Hp = new Helper(configuration);
        }

        [HttpGet]
        [Route("serverstatus")]
        public IActionResult GetServerStatus()
        {
            try
            {
                if (Hp.response.IsSuccessStatusCode)
                {
                    return Ok(new { server_accessible = true, message = "Server is accessible" });
                }
                else
                {
                    return Ok(new { server_accessible = false, message = "Server is not accessible" });
                }
            }
            catch (Exception ex)
            {

                return StatusCode(StatusCodes.Status503ServiceUnavailable, $"Error checking server status: {ex.Message}");
            }

        }

        [HttpGet]
        [Route("databasestatus")]
        public IActionResult GetDatabaseStatus()
        {
            try
            {
                if (Hp.cn.State == ConnectionState.Open)
                {
                    return Ok(new { database_accessible = true, message = "Database connection successful" });
                }
                else
                {
                    return Ok(new { database_accessible = false, message = "Database connection failed" });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status503ServiceUnavailable, $"Error checking database connection: {ex.Message}");
            }
        }

        [Authorize]
        [HttpGet]
        [Route("GetData")]
        public string GetData()
        {
            return "Authenticated with JWT Token";
        }

        [Authorize]
        [HttpGet]
        [Route("Details")]
        public string Details()
        {
            return "Authenticated with JWT Token";
        }

        [Authorize]
        [HttpPost]
        public string AddUser(Users user)
        {
            return "User added with username " + user.UserName;
        }



        //[HttpGet]
        //[Route("serverstatus")]
        //public IActionResult GetServerStatus()
        //{
        //    try
        //    {
        //        if (Hp.response.IsSuccessStatusCode)
        //        {
        //            return Ok(new { server_accessible = true, message = "Server is accessible" });
        //        }
        //        else
        //        {
        //            return Ok(new { server_accessible = false, message = "Server is not accessible" });
        //        }
        //    }
        //    catch (Exception ex)
        //    {

        //        return StatusCode(StatusCodes.Status503ServiceUnavailable, $"Error checking server status: {ex.Message}");
        //    }

        //}

        //[HttpGet]
        //[Route("databasestatus")]
        //public IActionResult GetDatabaseStatus()
        //{
        //    try
        //    {
        //        if (Hp.cn.State == ConnectionState.Open)
        //        {
        //            return Ok(new { database_accessible = true, message = "Database connection successful" });
        //        }
        //        else
        //        {
        //            return Ok(new { database_accessible = false, message = "Database connection failed" });
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        return StatusCode(StatusCodes.Status503ServiceUnavailable, $"Error checking database connection: {ex.Message}");
        //    }
        //}
    }
}
