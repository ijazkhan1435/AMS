using Microsoft.EntityFrameworkCore;

namespace ET_AMS_API.Models
{
    public class AMS_API_Dbcontext:DbContext
    {
        public AMS_API_Dbcontext(DbContextOptions<AMS_API_Dbcontext> options) : base(options)
        {
        }

        public DbSet<Users> UserProfile { get; set; }
    }
}
