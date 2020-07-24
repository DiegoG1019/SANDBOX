using System.Net;

namespace TCPTest.TCPShared
{
    public static class Config
    {
        public static readonly IPAddress Address = IPAddress.Parse("192.168.1.69");
        public const int Port = 1;

        public const int MessageBufferSize = 500;
        public const int HandshakeBufferSize = 500;
        public const int ConfirmationBufferSize = 200;

        public const int SocketSendTimeout = 500;
        public const int SocketReceiveTimeout = SocketSendTimeout;

        public const int UsernameMaxLenght = 20;

        public const int MainThreadSleepTime = 100;
        public const int ThReceptionSleepTime = 100;
        public const int ThConnectionsSleepTime = 100;
        public const int EmptyTransmissionQueueSleepTime = 500;

        public const string RecipientServer = "Server";
        public const string RecipientEveryone = "@All";

        public static readonly string[] BannedNames = { "", RecipientServer, "SERVER", RecipientEveryone };
        public static readonly char[] BannedCharacters = {
            '@', '{', '}', '[', ']', '$', '%', '^', '&', '/', '\\', '!', '#', '*', '(', ')', '"', '?', '+', '=', '-','|','\'','>','<','`','~'
        };
    }
}
