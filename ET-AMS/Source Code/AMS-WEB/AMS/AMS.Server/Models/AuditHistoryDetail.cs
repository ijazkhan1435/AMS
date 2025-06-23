using System.Runtime.ExceptionServices;

namespace AMS.Server.Models
{
    public class AuditHistoryDetails
    {
        public int AssetID { get; set; }
        public string? AuditStatus { get; set; }  // Nullable string
        public DateTime? AuditDateTime { get; set; }  // Nullable DateTime
        public string? Status { get; set; }  // Nullable string
        public string? Remarks { get; set; }  // Nullable string
        public string? EmployeeName { get; set; }  // Nullable string
        public string? SiteDescription { get; set; }  // Nullable string
        public int? LocationID { get; set; }  // Nullable int
        public string? LocationDescription { get; set; }  // Nullable string
        public int? SiteID { get; set; }  // Nullable int
        public bool? LocationIsActive { get; set; }  // Nullable bool
        public string? AssetDescription { get; set; }  // Nullable string
        public int TotalUniqueAssets { get; set; }
        public int CreatedBy { get; set; }
    }


    public class Reportdetail {
        public string CreateTimeStamp { get; set; }  // Nullable DateTime
        public int TotalUniqueAssets { get; set; }
        public int CreatedBy { get; set; }
    }
    //public class ViewDeatils
    //{
    //    public int AuditReportDetailId { get; set; }

    //    public int AssetID { get; set; }
    //    public string AuditStatus { get; set; }
    //    public string Email { get; set; }

    //    public string FirstName { get; set; }
    //    public string LastName { get; set; }
    //    public string Description { get; set; }
    //    public string SiteDescription { get; set; }


    //}
    public class ViewDeatils
    {
        public int AssetID { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Location { get; set; }
        public string SiteDescription { get; set; }
        public string AuditStatus { get; set; }
        public DateTime CreateTimeStamp { get; set; }
    }

}

