using System.Collections.Generic;
using System.Threading;
using TCPTest.TCPShared;
using static TCPTest.TCPClient.ClientProgram;

namespace TCPTest.TCPClient
{
    public static class ClientTransmission
    {

        private class SendMessage
        {
            public string Recipient;
            public Message Message;
            public SendMessage(string r, Message m)
            {
                Recipient = r;
                Message = m;
            }
        }

        public static Queue<Message> TransmissionQueue = new Queue<Message>();

        public static void SendMessages()
        {
            while (true)
            {
                Thread.Sleep(Config.MainThreadSleepTime);
                
                if(!(TransmissionQueue.Count > 0))
                {
                    Thread.Sleep(Config.EmptyTransmissionQueueSleepTime);
                    continue;
                }

                var msg = TransmissionQueue.Dequeue();

                var stream = MainClient.GetStream();
                var serializedmsg = msg.Serialize().ToArray();

                stream.Write(serializedmsg, 0, Config.MessageBufferSize);
            }
        }

        public static void Transmission_NewOutboundMessage(Message msg)
        {
            TransmissionQueue.Enqueue(msg);
        }
    }
}
