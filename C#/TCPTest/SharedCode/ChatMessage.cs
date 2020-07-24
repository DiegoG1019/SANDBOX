using System;
using Version = DiegoG.Utilities.Version;

namespace TCPTest.TCPShared
{
    class ChatMessage : Message
    {
        private string rtxt;
        public string Text
        {
            get
            {
                return rtxt;
            }
            set
            {
                LastEdit = DateTime.Now;
                IsEdited = true;
                rtxt = value;
            }
        }
        public bool IsEdited { get; protected set; }
        public DateTime LastEdit { get; protected set; }
        public DateTime SentTime { get; protected set; }
        public DateTime ReceivedTime { get; set; }


        public ChatMessage(Version clientversion, string msg, string sender) : base(clientversion, typeof(ChatMessage), sender)
        {
            rtxt = msg;
            IsEdited = false;
            SentTime = DateTime.Now;
            LastEdit = DateTime.Now;
            ReceivedTime = DateTime.MinValue;
        }

    }
}
