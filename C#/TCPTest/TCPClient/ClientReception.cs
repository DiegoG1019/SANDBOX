using Serilog;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Net.Sockets;
using System.Threading;
using TCPTest.TCPShared;
using static TCPTest.TCPClient.ClientProgram;

namespace TCPTest.TCPClient
{
    public static class ClientReception
    {
        public static ConcurrentDictionary<int, Message> ReceivedMessages = new ConcurrentDictionary<int, Message>();
        public static event IncomingMessage NewInboundMessage;

        public static void ReceiveMessage()
        {
            while (true)
            {
                Log.Verbose($"Setting Thread {Thread.CurrentThread.Name} to sleep");
                Thread.Sleep(Config.ThReceptionSleepTime);
                    
                var msgbuffer = new byte[Config.MessageBufferSize];

                var stream = MainClient.GetStream();

                stream.Read(msgbuffer, 0, Config.MessageBufferSize);

                var newmsg = Message.Deserialize(msgbuffer);
                ReceivedMessages.TryAdd(ReceivedMessages.Count, newmsg);

                var confirm = new Confirmation(Confirmation.Code.ReceivedSuccesfully);

                var confirmbuffer = new byte[Config.ConfirmationBufferSize];
                confirm.Serialize().ToArray().CopyTo(confirmbuffer, 0);

                stream.Write(confirmbuffer, 0, Config.ConfirmationBufferSize);

                NewInboundMessage(newmsg);

            }
        }
    }
}
