namespace TCPTest.TCPShared
{
    public class Slot<T> where T : class
    {
        private T obj;

        public bool IsFull
        {
            get
            {
                return obj != null;
            }
        }

        public bool Place(T obj)
        {
            if (IsFull)
            {
                return false;
            }
            this.obj = obj;
            return true;
        }

        public T Take()
        {
            var a = obj;
            obj = null;
            return a;
        }

        public T Peek()
        {
            return obj;
        }
    }
}
