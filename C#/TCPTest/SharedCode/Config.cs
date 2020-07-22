using System.Net;

namespace TCPTest.TCPShared
{
    public static class Config
    {
        public static readonly IPAddress Address = IPAddress.Parse("192.168.1.69");
        public const int Port = 1;
        public const int MessageBufferSize = 500;
        public const int HandshakeBufferSize = 500;
        public const int SocketSendTimeout = 500;
        public const int SocketReceiveTimeout = SocketSendTimeout;
        public const int UsernameMaxLenght = 20;
        public const int MainThreadSleepTime = 100;
        public static readonly string[] BannedNames = { "", "Server", "SERVER" };
    }
}
