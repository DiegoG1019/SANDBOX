using System;
using System.Collections.Generic;
using System.Net;
using System.Text;

namespace TCPTest
{
    namespace TCPShared
    {
        public static class SharedConfig
        {
            public static readonly IPAddress Address = IPAddress.Parse("192.168.1.69");
            public const int Port = 1;
        }
    }
}
