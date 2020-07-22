using System;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using Version = DiegoG.Utilities.Version;

namespace TCPTest.TCPShared
{
    public class Message
    {
        public Version UserClientVersion { get; private set; }
        public Type MessageType { get; private set; }

        public Message(Version ucv, Type mtype)
        {
            UserClientVersion = ucv;
            MessageType = mtype;
        }

        private static readonly BinaryFormatter Formatter = new BinaryFormatter();
        public Stream Serialize()
        {
            var stream = new MemoryStream();
            Formatter.Serialize(stream, this);
            return stream;
        }

        public static Message Deserialize(byte[] msg)
        {
            return Deserialize(new MemoryStream(msg));
        }
        public static Message Deserialize(Stream msg)
        {
            return (Message)Formatter.Deserialize(msg);
        }
    }
}
