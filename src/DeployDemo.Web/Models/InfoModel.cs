namespace DeployDemo.Web.Models
{
    public class InfoModel
    {
        public string Environment { get; set; }

        public bool IsProduction { get; set; }

        public string FileVersion { get; set; }

        public string ProductVersion { get; set; }

        public string ConnectionString { get; set; }
    }
}