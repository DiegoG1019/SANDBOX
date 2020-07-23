using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace TCPTest.TCPShared
{
    public static class Utilities
    {
        public static byte[] StreamToByteArray(Stream input)
        {
            byte[] bytes = new byte[input.Length];
            using(MemoryStream newstream = new MemoryStream())
            {
                int count;
                while((count = input.Read(bytes, 0, bytes.Length)) > 0)
                {
                    newstream.Write(bytes, 0, count);
                }
                return newstream.ToArray();
            }
        }
    }
}
