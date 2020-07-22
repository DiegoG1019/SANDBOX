using Serilog;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Net.Sockets;
using System.Threading;
using TCPTest.TCPShared;
using static TCPTest.TCPServer.Program;

namespace TCPTest.TCPServer
{
    public static class Reception
    {
        public static ConcurrentBag<Message> ReceivedMessages = new ConcurrentBag<Message>();
        public static event ServerMessage NewChatMessage;

        public static void ReceiveMessage()
        {
            while (true)
            {
                Log.Verbose($"Setting Thread {Thread.CurrentThread.Name} to sleep");
                Thread.Sleep(ThReceptionSleepTime);

                var msgbuffer = new byte[Config.MessageBufferSize];
                if (Serverflags.Get(Flags.AcceptIncomingMessages))
                {
                    foreach (KeyValuePair<string, Socket> usersocket in Connections.Active)
                    {
                        usersocket.Value.Receive(msgbuffer, SocketFlags.None, out SocketError socketError);
                        if (socketError == SocketError.Success)
                        {
                            var newmsg = Message.Deserialize(msgbuffer);
                            ReceivedMessages.Add(newmsg);
                            continue;
                        }
                        if (socketError != SocketError.TimedOut)
                        {
                            throw new Exception($"Socket Error: {socketError}; from User: {usersocket.Key}");
                        }
                    }
                }
            }
        }
    }
}
