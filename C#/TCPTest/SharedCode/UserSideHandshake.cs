using DiegoG.Utilities;

namespace TCPTest.TCPShared
{
    public class UserSideHandshake : Message
    {
        public string Username { get; private set; }

        public UserSideHandshake(Version clientversion, string user) : base(clientversion, typeof(UserSideHandshake))
        {
            Username = user;
        }

    }
}
