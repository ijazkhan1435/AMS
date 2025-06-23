using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ET_AMS_API.Models;
using System.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.AspNetCore.Authorization;
using static System.Runtime.InteropServices.JavaScript.JSType;
using Microsoft.EntityFrameworkCore;
using System.Data.Entity;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion.Internal;

namespace ET_AMS_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private IConfiguration _config;
        private readonly AMS_API_Dbcontext _dbcontext;
        public LoginController(IConfiguration configuration, AMS_API_Dbcontext dbcontext)
        {
            
            _dbcontext = dbcontext;
            _config = configuration;

        }

        [HttpGet]
        private Users AuthenticateUser(Users users)
        {
            Users _user = _dbcontext.UserProfile.Where(u => u.UserName == users.UserName && u.Password == users.Password).FirstOrDefault(); ;

            return _user;



           // if (user.UserName == "admin" && user.Password == "12345")
          //  {

          //      _user = new Users { UserName="Hasan Altaf"};
          //  }
           

        }
        private string GenerateToken(Users users)
        {
            var securitykey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]));
            var credentials = new SigningCredentials(securitykey, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(_config["Jwt:Issuer"], _config["Jwt:Audience"], null,
                expires: DateTime.Now.AddMinutes(1),
                signingCredentials: credentials


                );
            return new JwtSecurityTokenHandler().WriteToken(token);
        }
        [AllowAnonymous]
        [HttpPost]

        public IActionResult Login(Users users)
        {
            bool isAuthenticated = false;
            //IActionResult response = Unauthorized();
            var authenticatedUser = AuthenticateUser(users);

            if (authenticatedUser != null)
            {
                //var token = GenerateToken(authenticatedUser);
                //response = Ok(new { token = token });
                // response = Ok(authenticatedUser);
                isAuthenticated = true;
                return Ok(new { success = true, isAuthenticated, user = authenticatedUser });

            }
            else
            {
                return Ok(new { success = false, isAuthenticated });
            }

            //return Ok(isAuthenticated);
            //return response;
        }



    }
}
