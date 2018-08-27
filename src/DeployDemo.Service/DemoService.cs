using DeployDemo.Service.Support;
using Microsoft.Extensions.Hosting;
using NLog;
using System.ServiceProcess;

namespace DeployDemo.Service
{
    public partial class DemoService : ServiceBase
    {
        private readonly Logger logger = LogManager.GetCurrentClassLogger();

        public DemoService()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            var environment = new AppHostingEnvironment();

            logger.Info("DemoService started.");
            logger.Info($"Environment: {environment.EnvironmentName}");
            logger.Info($"Production: {environment.IsProduction()}");
        }

        protected override void OnStop()
        {
        }
    }
}
