    //using NSwag.Annotations;
using System.ComponentModel.DataAnnotations;
using Swashbuckle.AspNetCore.Swagger;

namespace ET_AMS_API.Models
{
    public class Users
    {
        [Key]
        public int UserId {  get; set; }
        public string UserName { get; set; }    
        public string Password { get; set; }
     
    }
}
