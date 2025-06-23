namespace AMS.Server.Models
{
    public class AssetCategoryCount
    {
        public string CategoryDescription { get; set; } // For the category description
        public int AssetCount { get; set; } // For the asset count in that category

    }
    public class Category
    {
        public int CategoryID { get; set; } // Ensure this matches your DB schema
        public string Description { get; set; } // Field for the category description
    }

}
