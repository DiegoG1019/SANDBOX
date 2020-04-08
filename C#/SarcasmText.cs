using System;
using System.Collections.Generic;

namespace alpha
{
    class SarcasmText
    {

        static void Main(string[] Args)
        {
            Console.Write("Introduce una oracion \n > ");
            string str = Console.ReadLine();

            char[] str2 = str.ToCharArray();

            Random random = new Random();

            for (int i = 0; i < str2.Length; i++)
            {
                int a = random.Next(0, 100);
                if(a > 49)
                {
                    str2[i] = Char.ToUpper(str2[i]);
                }
                else
                {
                    str2[i] = Char.ToLower(str2[i]);
                }
            }

            Console.WriteLine(" < {0}", new string(str2));

            Console.WriteLine("Presiona enter...");
            Console.ReadLine();
        }
    }
}