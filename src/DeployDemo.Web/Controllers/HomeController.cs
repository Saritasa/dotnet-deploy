using DeployDemo.Web.Models;
using DeployDemo.Web.Support;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;

namespace DeployDemo.Web.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index([FromServices] IHostingEnvironment hostingEnvironment)
        {
            var version = AppVersion.Get();

            var info = new InfoModel
            {
                Environment = hostingEnvironment.EnvironmentName,
                IsProduction = hostingEnvironment.IsProduction(),
                FileVersion = version.FileVersion,
                ProductVersion = version.ProductVersion,
            };

            return View(info);
        }
    }
}
