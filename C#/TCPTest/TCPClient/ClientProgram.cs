using Serilog;
using System;
using System.IO;
using System.Net.Sockets;
using System.Runtime.InteropServices;
using TCPTest.TCPShared;
using Version = DiegoG.Utilities.Version;

namespace TCPTest.TCPClient
{
    public class ClientProgram
    {

        [DllImport("kernel32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool AllocConsole();

        public static readonly Version ClientVersion = new Version("DGChatClient", 0, 0, 0, 0);
        public const string Servername = "DGChatServer";
        public const string Author = "Diego Garcia";
        public const string Appname = "DGChat - Server";
        public const string ShortAppname = "DGChatServer";
        public const string CopyrightNotice = "Copyright © 2020 Diego Garcia";


        public delegate void IncomingMessage(Message msg);

        public static Socket Server;
        public static class Directories
        {
            public static string DataOut = Path.Combine(ShortAppname);
            public static string Temp = Path.GetTempPath();
            public static string Working = Path.GetFullPath(Directory.GetCurrentDirectory());
            public static string Logging = Path.Combine(Working, "Logs");
            public static string Settings = Path.Combine(Working, "Settings");
            public static void InitDirectories()
            {
                Directory.CreateDirectory(DataOut);
                Directory.CreateDirectory(Logging);
                Directory.CreateDirectory(Settings);
            }
        }
        public static TcpClient MainClient { get; private set; }

        static void Main(string[] args)
        {
            /*--------------------------------------Initialization-------------------------------------*/

            Directories.InitDirectories();

            Configurations.Load();
            Configurations.LoadSystem();

            if (Configurations.System.Console)
            {
                Log.Information("Opening console");
                AllocConsole();
                Log.Information("Console opened");
            }

            var MinimumLoggerLevel = String.Empty;
            LoggerConfiguration loggerconfig = new LoggerConfiguration();
            if (Configurations.System.Verbose)
            {
                loggerconfig.MinimumLevel.Verbose();
                MinimumLoggerLevel = "Verbose";
            }
            else
            {
                if (Configurations.System.Debug)
                {
                    loggerconfig.MinimumLevel.Debug();
                    MinimumLoggerLevel = "Debug";
                }
                else
                {
                    loggerconfig.MinimumLevel.Information();
                    MinimumLoggerLevel = "Information";
                }
            }

            Log.Logger = loggerconfig
            .WriteTo.File(Path.Combine(Directories.Logging, String.Format("log - {0} - .txt", ClientVersion.Full)), rollingInterval: RollingInterval.Hour)
            .WriteTo.Console()
            .CreateLogger();

            Log.Debug($"Succesfully started logger with a mimum level of {MinimumLoggerLevel}");

            Log.Information("Program Author: {0}", Author);
            Log.Information("Running {1} version: {0}", ClientVersion.Full, Appname);

            Log.Information("DataOut Directory: {0}", Path.GetFullPath(Directories.DataOut));
            Log.Information("Logging Directory: {0}", Path.GetFullPath(Directories.Logging));
            Log.Information("Temp Directory: {0}", Path.GetFullPath(Directories.Temp));
            Log.Information("Working Directory: {0}", Path.GetFullPath(Directories.Working));

            MainClient = new TcpClient()
            {
                ReceiveBufferSize = Config.MessageBufferSize,
                ReceiveTimeout = Config.SocketReceiveTimeout,
                SendBufferSize = Config.MessageBufferSize,
                SendTimeout = Config.SocketSendTimeout
            };
            MainClient.Connect(Config.Address, Config.Port);
            Log.Debug("Started the Main Client and Connected to Server");
            
            /*-----------------------------------------Running-----------------------------------------*/

#if !DEBUG
            try
            {
#endif
                Log.Information($"The client is running at Address {Config.Address}:{Config.Port}");

#if !DEBUG
            }
            catch (Exception e)
            {
                Console.WriteLine("Error: " + e.StackTrace);
            }
#endif
        }
    }
}
