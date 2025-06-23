namespace AMS.Server.Models
{
    public class AssetsM // Notice this should be AssetM, not AssetsM
    {
        public int AssetID { get; set; }
        public string AssetTagId { get; set; }
        public string Description { get; set; }
        public decimal Cost { get; set; }
        public string Image { get; set; }
        public bool IsDepreciation { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreateTimeStamp { get; set; }
        public bool IsActive { get; set; }
        public int CategoryID { get; set; }
        public int StatusID { get; set; }
        public int LocationID { get; set; }
        public int SiteID { get; set; }
    }
}
