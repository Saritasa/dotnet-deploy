using System;
using System.Linq;
using System.Reflection;

namespace DeployDemo.Web.Support
{
    /// <summary>
    /// Contains info about app version.
    /// </summary>
    public class AppVersion
    {
        /// <summary>
        /// Short version. Contains major, minor, patch.
        /// </summary>
        public string FileVersion { get; set; }

        /// <summary>
        /// Long version. Contains Git branch and changeset.
        /// </summary>
        public string ProductVersion { get; set; }

        /// <summary>
        /// Returns app version using reflection.
        /// </summary>
        /// <returns></returns>
        public static AppVersion Get()
        {
            var entryAssembly = Util.GetEntryAssembly();

            var result = new AppVersion
            {
                FileVersion = entryAssembly.GetName().Version.ToString()
            };

            var attribute = entryAssembly.GetCustomAttributes(typeof(AssemblyInformationalVersionAttribute), false).FirstOrDefault()
                as AssemblyInformationalVersionAttribute;
            result.ProductVersion = attribute?.InformationalVersion;

            return result;
        }

        /// <inheritdoc/>
        public override string ToString()
        {
            return String.Format(@"{{""fileVersion"":""{0}"",""productVersion"":""{1}"" }}", FileVersion, ProductVersion);
        }
    }
}