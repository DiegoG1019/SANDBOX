using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using Version = DiegoG.Utilities.Version;

namespace TCPTest.TCPShared
{
    public class Message
    {
        public Version UserClientVersion { get; private set; }
        public Type MessageType { get; private set; }
        public string Sender { get; private set; }
        public List<string> Recipients { get; set; }
        public long MsgID { get; set; }

        public Message(Version ucv, Type mtype, string sender)
        {
            Sender = sender;
            UserClientVersion = ucv;
            MessageType = mtype;
        }

        private static readonly BinaryFormatter Formatter = new BinaryFormatter();
        public MemoryStream Serialize()
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
