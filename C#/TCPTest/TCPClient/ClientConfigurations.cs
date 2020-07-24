#define NOLOAD
#define VERBOSE

using Serilog;

namespace TCPTest.TCPClient
{
    public static class Configurations
    {

        public abstract class Category
        {
            public abstract void Default();
        }

        public class SystemCategory : Category
        {
            private bool __debug;
            private bool __verbose;

            public bool Debug
            {
                get
                {
                    return __debug;
                }
                set
                {
                    if (!value)
                    {
                        __debug = false;
                        __verbose = false;
                        return;
                    }
                    __debug = true;
                }
            }

            public bool Verbose
            {
                get
                {
                    return __verbose;
                }
                set
                {
                    if (value)
                    {
                        __debug = true;
                        __verbose = true;
                        return;
                    }
                    __verbose = false;
                }
            }

            public bool Console { get; set; }

            public override void Default()
            {
                Log.Information("Using default system configurations");
#if VERBOSE
                Verbose = false;
                Debug = true;
                Console = true;
#else
                RunningMode = RunningModes.Normal;
                Console = false;
#endif
            }

        }

        public static SystemCategory System { get; set; }

        public static void Load()
        {
#if NOLOAD
            System = new SystemCategory();
            return;
#endif
        }
        public static void LoadSystem()
        {
#if NOLOAD
            System.Default();
            return;
#endif
        }
        public static void SaveSystem()
        {

        }
    }
}
