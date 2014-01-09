using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using net.openstack.Core.Domain;
using net.openstack.Providers.Rackspace;

namespace $rootnamespace$.Samples.openstack.net
{
    public static class openstack
    {
        const string networkName = "OurNetwork";
        const string server1 = "Win2012";
        const string server2 = "Ubuntu13";
        const string containerName = "CDN_TEST";

        public static void RunAll(string username, string apikey)
        {

            // Connect and authenticate; keep this, we're going to use it all over the place.
            CloudIdentity cloudId = CreateIdentity(username, apikey);


            // Let's get a list of images.
            ListImages(cloudId);


            // Let's get a list of flavors.
            ListFlavors(cloudId);


            // Let's get a list of networks.
            ListNetworks(cloudId);


            // Supply the proper id's in the following to remove any networks.
            //RemoveNetwork("833094d8-df3b-43c9-8fbb-5f46f6f7cd45", cloudId);
            //RemoveNetwork("836343c4-b944-4a2d-9806-5f0a54ab7458", cloudId);
            //RemoveNetwork("5f090e4b-b1ec-4493-96bc-352cfbf6826d", cloudId);


            // The following are needed if you're going to spin up any servers.
            string imageId1 = "imageid_goes_here";
            string flavorId1 = "3";
            string region1 = "ORD";

            string imageId2 = "imageid_goes_here";
            string flavorId2 = "2";
            string region2 = "ORD";


            // The following should be pretty much self-explanatory.


            // Create a network.
            //CreateNetwork(networkName, cloudId);



            // Spin up two servers just to demonstrate more than one.
            // Note that this merely launches the create process on the server
            // side. You must wait until the servers are ready before using them.

            //SpinUpServerInNetwork(server1, imageId1, flavorId1, region1, cloudId);
            //SpinUpServerInNetwork(server2, imageId2, flavorId2, region2, cloudId);
            
            //CreateContainer(containerName, cloudId);
            
            //MakeContainerCDN(containerName, cloudId);
            
            //UploadFile(@"C:\InternetMinute.jpg", containerName, cloudId);
        }

        public static CloudIdentity CreateIdentity(string username, string apikey)
        {
            try
            {
                Console.Write("Creating Identity object...");
                CloudIdentity foo = new CloudIdentity() { Username = username, APIKey = apikey };
                Console.Write("Done.\n");
                return foo;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static void ListImages(CloudIdentity cloudId)
        {
            try
            {
                Console.Write("Getting list of all images with details...");
                CloudServersProvider csp = new CloudServersProvider(cloudId);
                System.Collections.IEnumerable images = csp.ListImagesWithDetails();
                Console.Write("Done.\n");
                foreach (ServerImage image in images)
                {
                    Console.WriteLine("Image name: {0}", image.Name);
                    Console.WriteLine("\tImage Id: {0}", image.Id);
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static void ListFlavors(CloudIdentity cloudId)
        {
            try
            {
                Console.Write("Getting list of all flavors with details...");
                CloudServersProvider csp = new CloudServersProvider(cloudId);
                System.Collections.IEnumerable flavors = csp.ListFlavorsWithDetails();
                Console.Write("Done.\n");
                foreach (FlavorDetails flavor in flavors)
                {
                    Console.WriteLine("Flavor name: {0}", flavor.Name);
                    Console.WriteLine("\tFlavor RAM: {0}MB", flavor.RAMInMB);
                    Console.WriteLine("\tFlavor DISK: (0)GB", flavor.DiskSizeInGB);
                    Console.WriteLine("\tFlavor ID: {0}", flavor.Id);
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static void ListNetworks(CloudIdentity cloudId)
        {
            try
            {
                Console.WriteLine("Getting list of all networks...");
                CloudNetworksProvider cnp = new CloudNetworksProvider(cloudId);
                IEnumerable<CloudNetwork> networks = cnp.ListNetworks(identity: cloudId);
                Console.WriteLine("Done.\n");
                foreach (CloudNetwork network in networks)
                {
                    Console.WriteLine("Network name: {0}", network.Label);
                    Console.WriteLine("\tNetwork Id: {0}", network.Id);
                }

            }
            catch (Exception ex)
            {
            }
        }

        public static void CreateNetwork(string networkname, CloudIdentity cloudId)
        {
            try
            {
                // Create Provider
                Console.Write("Creating Network...");
                CloudNetworksProvider cnp = new CloudNetworksProvider(cloudId);
                CloudNetwork cn = cnp.CreateNetwork("172.16.0.0/24", networkname);
                Console.Write("Done.\n");
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static void RemoveNetwork(string networkId, CloudIdentity cloudId)
        {
            try
            {
                // Create Provider
                Console.Write("Attempting to Remove Network {0}...", networkId);
                CloudNetworksProvider cnp = new CloudNetworksProvider(cloudId);
                cnp.DeleteNetwork(networkId);
                Console.Write("Done.\n");
            }
            catch (Exception ex)
            {
                Console.Write("Done.\n");
                //throw;
            }
        }

        public static void SpinUpServerInNetwork(string servername, string imageId, string flavorId, string region, CloudIdentity cloudId)
        {
            try
            {
                // Create Provider
                Console.Write("Creating Server {0}...", servername);
                CloudServersProvider csp = new CloudServersProvider(cloudId);

                // Spin up a new Server
                NewServer newServer = csp.CreateServer(servername, imageId, flavorId, region: region);
                Console.Write("Done.\n");
                Console.WriteLine("Administrator Password for new server {0} is {1}", servername, newServer.AdminPassword);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static void CreateContainer(string containername, CloudIdentity cloudId)
        {
            try
            {
                CloudFilesProvider cfp = new CloudFilesProvider(cloudId);
                ObjectStore objstr = cfp.CreateContainer(containername);
            }
            catch (Exception ex)
            {
            }
        }

        public static void MakeContainerCDN(string containername, CloudIdentity cloudId)
        {
            try
            {
                CloudFilesProvider cfp = new CloudFilesProvider(cloudId);
                cfp.EnableCDNOnContainer(containername, true);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static void UploadFile(string filepath, string containername, CloudIdentity cloudId)
        {
            try
            {
                CloudFilesProvider cfp = new CloudFilesProvider(cloudId);
                cfp.CreateObjectFromFile(containername, filepath);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
    }
}
