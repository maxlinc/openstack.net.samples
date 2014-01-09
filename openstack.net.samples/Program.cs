using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace openstack.net.samples
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length != 2)
            {
                System.Console.WriteLine("Usage: openstack.net.samples.exe <username> <api_key>");
                return 1;
            }

            try
            {
                var userid = args[0];
                var apikey = args[1];

                Samples.openstack.net.openstack.Authenticate(userid, apikey);
                Samples.openstack.net.openstack.RunAll(userid, apikey);
                Samples.openstack.net.openstack.RunCreateContainer(userid, apikey);
                Samples.openstack.net.openstack.RunUpload(userid, apikey);
                Samples.openstack.net.openstack.RunUploadFolder(userid, apikey);
                Samples.openstack.net.openstack.RunDownload(userid, apikey);
                Samples.openstack.net.openstack.RunDelete(userid, apikey);
                //Samples.openstack.net.openstack.RunDelete(userid, apikey);



                Console.WriteLine("Press any key to continue . . . ");
                Console.ReadKey(true);

            }
            catch (Exception ex)
            {
                Console.WriteLine("ERROR OCCURRED!");
                Console.WriteLine("ERROR: {0}", ex.Message);
                Console.WriteLine("Press any key to continue . . . ");
                Console.ReadKey(true);
            }
        }
    }
}
