using DiegoG.Utilities;
using Serilog;
using System;
using System.IO;
using System.Net.Sockets;
using System.Runtime.InteropServices;
using System.Threading;
using TCPTest.TCPShared;
using Version = DiegoG.Utilities.Version;

namespace TCPTest.TCPServer
{
    public static class ServerProgram
    {
        [DllImport("kernel32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool AllocConsole();

        public static readonly Version ServerVersion = new Version("DGChatServer", 0, 0, 0, 0);
        public const string Servername = "DGChatServer";
        public const string Author = "Diego Garcia";
        public const string Appname = "DGChat - Server";
        public const string ShortAppname = "DGChatServer";
        public const string CopyrightNotice = "Copyright © 2020 Diego Garcia";

        public static Thread ThConnections;
        public static Thread ThReception;

        public enum Flags
        {
            AcceptNewConnections, AcceptIncomingMessages
        }
        public static class Serverflags
        {
            public static BitsByte Array_Active = new BitsByte();
            public static bool Get(Flags index)
            {
                return Array_Active[(int)index];
            }
            public static void Set(Flags index, bool value)
            {
                Array_Active[(int)index] = value;
            }
            /// <summary>
            /// Flip the desired bit and returns the value post-flip
            /// </summary>
            /// <param name="index"></param>
            /// <returns></returns>
            public static bool Flip(Flags index)
            {
                Set(index, !Get(index));
                return Get(index);
            }
        }
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

        public delegate void ServerMessage(Message msg);

        public static TcpListener MainListener { get; private set; }

        [STAThread]
        public static void Main()
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
            .WriteTo.File(Path.Combine(Directories.Logging, String.Format("log - {0} - .txt", ServerVersion.Full)), rollingInterval: RollingInterval.Hour)
            .WriteTo.Console()
            .CreateLogger();

            Log.Debug($"Succesfully started logger with a mimum level of {MinimumLoggerLevel}");

            Log.Information("Program Author: {0}", Author);
            Log.Information("Running {1} version: {0}", ServerVersion.Full, Appname);

            Log.Information("DataOut Directory: {0}", Path.GetFullPath(Directories.DataOut));
            Log.Information("Logging Directory: {0}", Path.GetFullPath(Directories.Logging));
            Log.Information("Temp Directory: {0}", Path.GetFullPath(Directories.Temp));
            Log.Information("Working Directory: {0}", Path.GetFullPath(Directories.Working));

            MainListener = new TcpListener(Config.Address, Config.Port);
            MainListener.Start();

            Log.Debug("Started the Main Listener");

            //
            var thCname = "ThConnections";
            Log.Debug($"Starting {thCname} Thread");
            ThConnections = new Thread(new ThreadStart(Connections.ReceiveConnection))
            {
                Name = thCname
            };
            ThConnections.Start();
            Log.Debug($"Thread {thCname} started");
            //
            var thRname = "ThReception";
            Log.Debug($"Starting {thRname} Thread");
            ThReception = new Thread(new ThreadStart(Reception.ReceiveMessage))
            {
                Name = thRname
            };
            ThReception.Start();
            Log.Debug($"Thread {thRname} started");
            //
            var thSname = "ThTransmission";
            Log.Debug($"Starting {thSname} Thread");
            ThReception = new Thread(new ThreadStart(Transmission.SendMessages))
            {
                Name = thSname
            };
            ThReception.Start();
            Log.Debug($"Thread {thSname} started");
            //

            Log.Debug("Registering Transmission.Reception_NewMessage to NewMessage event");
            Reception.NewMessage += Transmission.Reception_NewMessage;

            Log.Information("Finished the Initialization of the Application");

            /*-----------------------------------------Running-----------------------------------------*/

#if !DEBUG
            try
            {
#endif
            Log.Information($"The server is running at Address {Config.Address}:{Config.Port} with Endpoint: {MainListener.LocalEndpoint}");

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
