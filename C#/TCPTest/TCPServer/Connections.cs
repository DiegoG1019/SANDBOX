using Serilog;
using System.Collections.Concurrent;
using System.Net.Sockets;
using System.Threading;
using TCPTest.TCPShared;
using static TCPTest.TCPServer.ServerProgram;

namespace TCPTest.TCPServer
{
    public static class Connections
    {
        public static ConcurrentDictionary<string, Socket> Active { get; private set; }
        public static byte MaxUsers = 10;

        public static event ServerMessage NewHandshake;
        public static event ServerMessage Disconnection;

        static Connections()
        {
            Active = new ConcurrentDictionary<string, Socket>();
        }

        public static void ReceiveConnection()
        {
            while (true && Active.Count < MaxUsers)
            {
                Log.Verbose($"Setting Thread {Thread.CurrentThread.Name} to sleep");
                Thread.Sleep(Config.ThConnectionsSleepTime);

                if (Serverflags.Get(Flags.AcceptNewConnections))
                {
                    var socket = MainListener.AcceptSocket();
                    byte[] handshakebuffer = new byte[Config.HandshakeBufferSize];
                    socket.Receive(handshakebuffer);
                    var handshake = (UserSideHandshake)Message.Deserialize(handshakebuffer);
                    if (
                           handshake.UserClientVersion.Minor <= ServerVersion.Minor
                        && handshake.UserClientVersion.Major == ServerVersion.Major
                        && !(Utilities.StringContains(handshake.Username, Config.BannedCharacters))
                        && !(Utilities.StringContains(handshake.Username, Config.BannedNames))
                        && !(Active.ContainsKey(handshake.Username))
                    )
                    {
                        socket.ReceiveTimeout = Config.SocketReceiveTimeout;
                        socket.SendTimeout = Config.SocketSendTimeout;
                        Active.TryAdd(handshake.Username, socket);
                    }
                    else
                    {
                        socket.Disconnect(true);
                    }
                }
            }
        }
    }
}