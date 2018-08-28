using DeployDemo.Web.Models;
using DeployDemo.Web.Support;
using Microsoft.Extensions.Hosting;
using System.Web.Mvc;

namespace DeployDemo.Web.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            var environment = new WebHostingEnvironment();
            var version = AppVersion.Get();

            var info = new InfoModel
            {
                Environment = environment.EnvironmentName,
                IsProduction = environment.IsProduction(),
                FileVersion = version.FileVersion,
                ProductVersion = version.ProductVersion,
            };

            return View(info);
        }
    }
}