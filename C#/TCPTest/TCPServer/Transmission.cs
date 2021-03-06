﻿using System.Collections.Generic;
using System.Threading;
using TCPTest.TCPShared;

namespace TCPTest.TCPServer
{
    public static class Transmission
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

        private static readonly ThreadStart ths = new ThreadStart(Transmit);
        private static readonly Slot<SendMessage> MessageRecipients = new Slot<SendMessage>();

        public static void Transmit()
        {
            const int MaxAttempts = 3;
            int attempts = 0;
            var recipient = MessageRecipients.Take();
            var recsocket = Connections.Active[recipient.Recipient];
            var msg = recipient.Message.Serialize().ToArray();
            byte[] confirmationarray = new byte[Config.ConfirmationBufferSize];

            SendMessage:;
            recsocket.Send(msg);
            recsocket.Receive(confirmationarray);
            if (Confirmation.Deserialize(confirmationarray).ConfirmationCode != Confirmation.Code.ReceivedSuccesfully && attempts <= MaxAttempts)
            {
                attempts++;
                goto SendMessage;
            }
        }

        public static void SendMessages()
        {
            while (true)
            {
                Thread.Sleep(Config.MainThreadSleepTime);
                if(TransmissionQueue.Count <= 0)
                {
                    Thread.Sleep(Config.EmptyTransmissionQueueSleepTime);
                    continue;
                }
                var msg = TransmissionQueue.Dequeue();
                foreach (string recipient in msg.Recipients)
                {
                    MessageRecipients.Place(new SendMessage(recipient, msg));
                    new Thread(ths).Start();
                    Thread.Sleep(100);
                }
            }
        }

        public static void Reception_NewMessage(Message msg)
        {
            if (msg.Recipients.Contains(Config.RecipientEveryone))
            {
                var nl = new List<string>();
                foreach(string r in Connections.Active.Keys)
                {
                    nl.Add(r);
                }
                msg.Recipients = nl;
            }
            TransmissionQueue.Enqueue(msg);
        }
    }
}
