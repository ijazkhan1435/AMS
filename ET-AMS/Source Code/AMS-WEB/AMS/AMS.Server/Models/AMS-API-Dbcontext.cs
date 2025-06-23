using AMS.Server.Models;
using Microsoft.EntityFrameworkCore;

namespace ET_AMS_API.Models
{
    public class AMS_API_Dbcontext:DbContext
    {
        public AMS_API_Dbcontext(DbContextOptions<AMS_API_Dbcontext> options) : base(options)
        {
        }

        public DbSet<Users> UserProfile { get; set; }
        public DbSet<AuditHistoryDetails> AuditHistoryDetails { get; set; }
        public DbSet<Reportdetail> Reportdetail { get; set; }
        public DbSet<AssetsM> AssetsM { get; set; }
        public DbSet<Assets> Assets { get; set; }
        public DbSet<UserProfile> UserProfiles { get; set; }
        public DbSet<AssetStatusCountModel> AssetStatusCountModel { get; set; }
        public DbSet<Status> Status { get; set; }
        public DbSet<AssetDto> AssetDto { get; set; }
        public DbSet<UniqueAssetDto> UniqueAssetDto { get; set; }
        public DbSet<AssetCategoryCount> AssetCategoryCount { get; set; }
       // public DbSet<AssetCategoryCount> Category { get; set; }
        public DbSet<Category> Category { get; set; }
        public DbSet<UniqueAssetDto> UniqueAssets { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<AssetsM>().ToTable("AssetsM"); // Map to the correct table name
            modelBuilder.Entity<AssetsM>().HasKey(a => a.AssetID); // Ensure this entity has a primary key

            modelBuilder.Entity<AuditHistoryDetails>().HasNoKey(); // Keyless entity
            modelBuilder.Entity<Reportdetail>().HasNoKey(); // Keyless entity
            modelBuilder.Entity<UserProfile>().HasNoKey();
            modelBuilder.Entity<AssetStatusCountModel>().HasNoKey();
            modelBuilder.Entity<AssetCategoryCount>().HasNoKey();
            modelBuilder.Entity<AssetDto>().HasNoKey();
            modelBuilder.Entity<Assets>().HasNoKey();
            modelBuilder.Entity<UniqueAssetDto>().HasNoKey();
          
            base.OnModelCreating(modelBuilder);
        }


    }
}
