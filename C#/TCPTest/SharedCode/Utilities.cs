using System.IO;

namespace TCPTest.TCPShared
{
    public static class Utilities
    {
        public static byte[] StreamToByteArray(Stream input)
        {
            byte[] bytes = new byte[input.Length];
            using (MemoryStream newstream = new MemoryStream())
            {
                int count;
                while ((count = input.Read(bytes, 0, bytes.Length)) > 0)
                {
                    newstream.Write(bytes, 0, count);
                }
                return newstream.ToArray();
            }
        }

        public static bool StringContains(string str, char c)
        {
            return StringContains(str, c.ToString());
        }
        public static bool StringContains(string str, string c)
        {
            if (string.Compare(str, c) > 0)
            {
                return true;
            }
            return false;
        }
        public static bool StringContains(string str, string[] c)
        {
            foreach(string s in c)
            {
                if(StringContains(str, s))
                {
                    return true;
                }
            }
            return false;
        }
        public static bool StringContains(string str, char[] c)
        {
            foreach(char ch in c)
            {
                if(StringContains(str, ch))
                {
                    return true;
                }
            }
            return false;
        }
    }
}
