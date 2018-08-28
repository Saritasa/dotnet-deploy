using System.Reflection;

namespace DeployDemo.Web.Support
{
    public class Util
    {
        public static Assembly GetEntryAssembly()
        {
            var result = Assembly.GetEntryAssembly();

            if (result != null)
            {
                return result;
            }

            if (System.Web.HttpContext.Current == null ||
                System.Web.HttpContext.Current.ApplicationInstance == null)
            {
                return null;
            }

            var type = System.Web.HttpContext.Current.ApplicationInstance.GetType();
            while (type != null && type.Namespace == "ASP")
            {
                type = type.BaseType;
            }

            return type == null ? null : type.Assembly;
        }
    }
}