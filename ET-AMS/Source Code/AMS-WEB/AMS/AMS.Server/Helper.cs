using System.Configuration;
using System.Data;
using System.Data.SqlClient;
//using Microsoft.Data.SqlClient;

namespace ET_AMS_API
{
    public class Helper
    {
        public string? connectionString = null;
        private string? ServerUrl = null;
        private HttpClient client;
        public HttpResponseMessage response;
        public SqlConnection cn;
        private SqlCommand? cmd = null;
        private SqlDataAdapter? sda = null;
        private DataTable? dt = null;

        public Helper(IConfiguration configuration)
        {
            connectionString = configuration.GetConnectionString("ET_AMS_APIContext");
            ServerUrl = configuration["AppSettings:ServerUrl"];
            client = new HttpClient();
            response = client.GetAsync(ServerUrl).Result;
            cn = new SqlConnection(connectionString);
            cn.Open();
        }
        public Helper()
        {
            connectionString = "Server=Ahtsham-PC;Database=AMS_Demo;User=sa;Password=123;Encrypt=True;TrustServerCertificate=True;";
            cn = new SqlConnection(connectionString);
            cn.Open();

        }
        public DataSet GetDataset(String Query)
        {
            DataSet ds = new DataSet();
            try
            {
                cmd = new SqlCommand(Query, cn);
                cmd.CommandTimeout = 120; // Timeout in seconds.
                sda = new SqlDataAdapter(cmd);
                dt = new DataTable();
                sda.Fill(dt);
                ds.Tables.Add(dt);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
            finally
            {
                //cn.Close();
            }

            return ds;
        }

        public bool PostDataset(String Query)
        {
            try
            {
                cmd = new SqlCommand(Query, cn);
                cmd.CommandTimeout = 120; // Timeout in seconds.
                cmd.ExecuteNonQuery();
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
                return false;
            }
            finally
            {
                //cn.Close();
            }
        }

        ~Helper()
        {
            
            cn.Close();
        }
    }
}
