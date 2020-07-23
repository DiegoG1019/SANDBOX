using System;
//This is so that you don't have to go KeyManager.Key or KeyManager.Lock, instead, simply use Lock or Key. HOWEVER, KeyManager is a class, not a namespace. Hence "static"
//But it only allows access to static members, obviously.
using static ConsoleApp1.KeyManager;

namespace ConsoleApp1
{

    public class Pene
    {
        //Set should always be private, for rather obvious reasons.
        //In fact, the only reason ISafe is an interface is so you can inherit some other class, since C# doesn't support multiple inheritance
        public Lock<byte, bool> KeyLock { get; private set; }

        //You uh. Usually shouldn't be doing this. But whatever.
        //You do, however, need to have a key already generated before creating a lock.
        //One lock can respond to multiple keys, too.
        public Key AccessKey = IssueNewKey();
        public Key BackupKey = IssueNewKey();

        public Pene()
        {
            KeyLock = new Lock<byte, bool>(false, AccessKey, BackupKey, Program.MasterKey)
            {
                SafeAccessLockedData = new System.Collections.Generic.Dictionary<byte, bool>
                {
                    { 0, false },
                    { 1, true },
                    { 2, false },
                    { 3, false }
                }
            };
            KeyLock.Arm(AccessKey);
        }
    }

    static class Program
    {

        //Usually poor practice.
        private static void print(object s)
        {
            Console.WriteLine(s);
        }

        public static Key MasterKey = IssueNewKey();

        static void Main(string[] args)
        {
            print("Starting Key & Lock example");


            var G0ev0 = new Pene();
            var Pipi = new Pene();

            print($"Master Key: {MasterKey}");
            print($"G0ev0's Keys: Access {G0ev0.AccessKey}, Backup: {G0ev0.BackupKey}");
            print($"Pipi's Keys: Access {Pipi.AccessKey}, Backup: {Pipi.BackupKey}");

            if (G0ev0.KeyLock.IsArmed)
            {
                if (G0ev0.KeyLock.TryKey(G0ev0.AccessKey))
                {
                    G0ev0.KeyLock.Disarm(G0ev0.AccessKey);
                }
            }

            if (! G0ev0.KeyLock.IsArmed)
            {
                print($"G0ev0's LockedData index 0: {G0ev0.KeyLock.LockedData[0]}");
            }

            G0ev0.KeyLock.Arm(G0ev0.BackupKey);

            print($"Pipi Locked Data index 2 {Pipi.KeyLock.TryGetSafeData(MasterKey, 2)}");

            print($"Should Jal go through door number 2? {Pipi.KeyLock.GetSafeData(Pipi.BackupKey, 2)}");

        }
    }
}
