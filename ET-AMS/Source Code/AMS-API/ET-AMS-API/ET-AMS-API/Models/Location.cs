namespace ET_AMS_API.Models
{
    public class Location
    {
        // Location properties
        public int LocationID { get; set; }
        public string LocationDescription { get; set; }
        public int SiteID { get; set; }
        public bool LocationIsActive { get; set; }
        public int LocationCreatedBy { get; set; }
        public DateTime LocationCreateTimeStamp { get; set; }

        // Asset properties
        public int AssetID { get; set; }
        public string AssetBarcode { get; set; } // Changed from AssetTagID to AssetBarcode
       public string AssetTagID { get; set; }
        public string AssetDescription { get; set; }
        public decimal Cost { get; set; }
        public string Image { get; set; }
        public bool IsDepreciation { get; set; }
        public int AssetCreatedBy { get; set; }
        public int AssetCategoryID { get; set; }
        public int HistoryRemarks { get; set; }
        public int HistoryCreateTimeStamp { get; set; }
        public DateTime AssetCreateTimeStamp { get; set; }
        public int CategoryID { get; set; }

        // AssetHistory properties
        public int AssetHistoryID { get; set; }
        public string StatusHistory { get; set; }
        public int EmployeeID { get; set; }
        public DateTime AssetHistoryCreateTimeStamp { get; set; } // Changed from CreateTimeStamp to AssetHistoryCreateTimeStamp
        public string Remarks { get; set; }
        public bool AssetIsActive { get; set; } // Changed from Status to AssetIsActive

        public string SiteDescription { get; set; }
        public string CategoryDescription { get; set; }
        public int SiteCreatedBy { get; set; }
        public string EmployeeName { get; set; }
      

    }

    public class LocationFilterRequest
    {
        public int SiteID { get; set; }
    }


    public class Locations
    {
        public int LocationID { get; set; }
        public string LocationDescription { get; set; }
        public int SiteID { get; set; }
        public string SiteDescription { get; set; }


    }
    public class AuditReportDetail
    {
        public int AuditReportDetailId { get; set; } // This is auto-incremented in the database
        public int AssetId { get; set; }
        public string AuditStatus { get; set; }
        public int CreatedBy { get; set; }
        public DateTime AuditDateTime { get; set; } // This will be set to the current date and time
    }
    public class CraeteAsset
    {
        public string AssetTagID { get; set; }
        public decimal Cost { get; set; }
        public int LocationID { get; set; }
        public string Image { get; set; }
        public bool IsDepreciation { get; set; }
        public string Description { get; set; }
        public int CategoryID { get; set; }
        public int CreatedBy { get; set; }
        public string Remarks { get; set; }
        public string Status { get; set; }
        public DateTime CreateTimeStamp { get; set; }
        public int EmployeeID { get; set; }
    }

}
