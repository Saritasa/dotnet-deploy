using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting;
using System.Configuration;
using System.IO;
using System.Reflection;

namespace DeployDemo.Service.Support
{
    public class AppHostingEnvironment : IHostingEnvironment
    {
        private readonly string environment;
        private readonly string applicationName;
        private readonly string contentRootPath;

        public AppHostingEnvironment()
        {
            environment = ConfigurationManager.AppSettings["Environment"];

            var entryAssembly = Assembly.GetEntryAssembly();
            applicationName = entryAssembly.GetName().Name;
            contentRootPath = Path.GetDirectoryName(entryAssembly.Location);
        }

        public string EnvironmentName { get => environment; set => throw new System.NotImplementedException(); }
        public string ApplicationName { get => applicationName; set => throw new System.NotImplementedException(); }
        public string ContentRootPath { get => contentRootPath; set => throw new System.NotImplementedException(); }
        public IFileProvider ContentRootFileProvider { get => throw new System.NotImplementedException(); set => throw new System.NotImplementedException(); }
    }
}
