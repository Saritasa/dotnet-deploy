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
        }

        protected override void OnStop()
        {
        }
    }
}
