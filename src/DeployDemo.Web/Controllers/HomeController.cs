using Microsoft.AspNetCore.Mvc;

namespace DeployDemo.Web.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
