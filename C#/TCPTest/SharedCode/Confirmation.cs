using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

namespace TCPTest.TCPShared
{
    public class Confirmation
    {

        public enum Code
        {
            ReceivedSuccesfully, Failure
        }

        public Code ConfirmationCode;

        public Confirmation(Code code)
        {
            ConfirmationCode = code;
        }

        private static readonly BinaryFormatter Formatter = new BinaryFormatter();
        public MemoryStream Serialize()
        {
            var stream = new MemoryStream();
            Formatter.Serialize(stream, this);
            return stream;
        }

        public static Confirmation Deserialize(byte[] msg)
        {
            return Deserialize(new MemoryStream(msg));
        }
        public static Confirmation Deserialize(Stream msg)
        {
            return (Confirmation)Formatter.Deserialize(msg);
        }

    }
}
