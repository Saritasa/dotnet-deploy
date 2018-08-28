using DeployDemo.Web.Models;
using DeployDemo.Web.Support;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace DeployDemo.Web.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index([FromServices] IHostingEnvironment hostingEnvironment,
            [FromServices] IConfiguration configuration)
        {
            var version = AppVersion.Get();

            var info = new InfoModel
            {
                Environment = hostingEnvironment.EnvironmentName,
                IsProduction = hostingEnvironment.IsProduction(),
                FileVersion = version.FileVersion,
                ProductVersion = version.ProductVersion,
                ConnectionString = configuration.GetConnectionString("Demo"),
            };

            return View(info);
        }
    }
}
