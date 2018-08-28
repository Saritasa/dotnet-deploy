using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting;
using System.Configuration;
using System.IO;
using System.Reflection;

namespace DeployDemo.Web.Support
{
    public class WebHostingEnvironment : IHostingEnvironment
    {
        private readonly string environment;
        private readonly string applicationName;
        private readonly string contentRootPath;

        public WebHostingEnvironment()
        {
            environment = ConfigurationManager.AppSettings["Environment"];

            var entryAssembly = Util.GetEntryAssembly();
            applicationName = entryAssembly.GetName().Name;
            contentRootPath = Path.GetDirectoryName(System.Web.HttpContext.Current.Request.MapPath(""));
        }

        public string EnvironmentName { get => environment; set => throw new System.NotImplementedException(); }
        public string ApplicationName { get => applicationName; set => throw new System.NotImplementedException(); }
        public string ContentRootPath { get => contentRootPath; set => throw new System.NotImplementedException(); }
        public IFileProvider ContentRootFileProvider { get => throw new System.NotImplementedException(); set => throw new System.NotImplementedException(); }
    }
}
