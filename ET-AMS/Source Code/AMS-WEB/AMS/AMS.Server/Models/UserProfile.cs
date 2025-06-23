namespace AMS.Server.Models
{
    public class UserProfile
    {
        public int UserId { get; set; }
        public string UserName { get; set; }
        public string CreatedBy { get; set; }
        public int RolesId { get; set; }
        public string Password { get; set; }
        public bool IsEnabled { get; set; }
    }

   
}
