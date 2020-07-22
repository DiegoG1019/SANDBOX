using DiegoG.Utilities;

namespace TCPTest.TCPShared
{
    public class ServerSideHandshake : Message
    {
        public string Servername { get; private set; }

        public ServerSideHandshake(Version serverver, string servername) : base(serverver, typeof(ServerSideHandshake))
        {
            Servername = servername;
        }

    }
}
