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
        public static event IncomingMessage NewMessage;

        public static void ReceiveMessage()
        {
            while (true)
            {
                Log.Verbose($"Setting Thread {Thread.CurrentThread.Name} to sleep");
                Thread.Sleep(Config.ThReceptionSleepTime);
                    
                var msgbuffer = new byte[Config.MessageBufferSize];
                Server.Receive(msgbuffer, SocketFlags.None, out SocketError socketError);
                if (socketError == SocketError.Success)
                {
                    var newmsg = Message.Deserialize(msgbuffer);
                    ReceivedMessages.TryAdd(ReceivedMessages.Count, newmsg);
                    newmsg.MsgID = ReceivedMessages.Count;
                    NewMessage(newmsg);
                    continue;
                }
                if (socketError != SocketError.TimedOut)
                {
                    throw new Exception($"Socket Error: {socketError} from Server");
                }
            }
        }
    }
}
