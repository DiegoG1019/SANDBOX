using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using TCPTest.TCPShared;

namespace TCPTest.TCPServer
{
    public static class Transmission
    {
        public static ConcurrentQueue<Message> TransmissionQueue = new ConcurrentQueue<Message>();

        private static ThreadStart ths = new ThreadStart(Transmit);

        //This is supposed to transmit the next entry in transmission queue to all recipients, in a one thread, one recipient basis.
        //For each succesful recipient reception it should be removed from the list, and once the list is down to 0, it gets removed from the queue
        //Each recipient will be subjected to a total of three attempts, if all three fail the thread will end.
        //If all threads end and the message is still in the queue, it gets sent to the back.
        //Each message can only be sent to the back a total of three times. If all three fail, it gets reported as "Unable to send"
        //The recipient list members that don't match to a socket are ignored and removed.
        public static void Transmit()
        {
            
        }

        public static void Reception_NewMessage(Message msg)
        {
        }
    }
}
