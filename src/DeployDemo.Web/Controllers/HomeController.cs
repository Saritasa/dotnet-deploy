using DeployDemo.Web.Models;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;

namespace DeployDemo.Web.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index([FromServices] IHostingEnvironment hostingEnvironment)
        {
            var info = new InfoModel
            {
                Environment = hostingEnvironment.EnvironmentName,
                IsProduction = hostingEnvironment.IsProduction(),
            };

            return View(info);
        }
    }
}
