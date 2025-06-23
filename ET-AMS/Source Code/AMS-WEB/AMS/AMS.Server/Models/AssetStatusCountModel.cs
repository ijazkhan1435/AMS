namespace AMS.Server.Models
{
    public class AssetStatusCountModel
    {
        public string StatusDescription { get; set; }
        public int AssetCount { get; set; }

    }
    public class Status
    {
        public int StatusID { get; set; }
        public string Description { get; set; }
    }
}
