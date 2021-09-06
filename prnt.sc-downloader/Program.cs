using System;
using System.Threading.Tasks;
using System.Net.Http;
using System.Threading;
using System.Collections.Generic;
using Nito.AsyncEx;
using System.Linq;
using System.Text;
using HtmlAgilityPack;
using System.IO;

namespace prnt.sc_downloader
{
    static partial class Program
    {
        public const int IdLength = 6;
        public const string BaseUrl = "https://prnt.sc/";
        public const string Except = "st.prntscr.com/2021/04/08/1538/img/0_173a7b_211be8ff.png";
        public const long MaxSize = 10L * 1024L * 1024L * 1024L;
        //                         GB    MB     KB      B

        private static readonly int ParallelizationIndex = Environment.ProcessorCount * 4;
        private static readonly SemaphoreSlim ParallelizationSemaphore;
        private static readonly Random Rand;
        private static readonly HttpClient Http;
        private static readonly HtmlWeb Html;
        private static readonly char[] CharPool;
        private static readonly int CharPoolEnd;
        private static readonly string SavePath;

        private static DateTime CheckDirRefresh;
        
        static Program()
        {
            ParallelizationSemaphore = new(ParallelizationIndex, ParallelizationIndex);
            Rand = new(DateTime.Now.Millisecond);
            Http = new();
            Html = new();
            SavePath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), "prntscdownloader");
            Directory.CreateDirectory(SavePath);
            CheckDirRefresh = DateTime.Now;

            CharPool = new char[] { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };
            CharPoolEnd = CharPool.Length - 1;
        }

        static async Task Main(string[] args)
        {
            Queue<LinkedListNode<Task>> RemovalQueue = new(ParallelizationIndex);
            LinkedList<Task> RunningTasks = new();
            Task<long>? CheckDir = null;

            while (true)
            {
                await Task.Delay(1000);

                if (CheckDir is null && CheckDirRefresh < DateTime.Now)
                {
                    Console.WriteLine("Checking Directory Size");
                    CheckDir = CheckDirectorySize();
                    CheckDirRefresh = DateTime.Now + TimeSpan.FromMinutes(10);
                }

                if (CheckDir is not null && CheckDir.IsCompleted)
                {
                    var t = CheckDir;
                    CheckDir = null;
                    long cs = await t;
                    if(cs > MaxSize)
                    {
                        Console.WriteLine("The directory got too large! Shutting down.");
                        return;
                    }
                    Console.WriteLine($"Current directory size is {cs}");
                }

                while (true)
                    if (await ParallelizationSemaphore.WaitAsync(100))
                        RunningTasks.AddLast(Fetch(GenLink()));
                    else
                        break;

                LinkedListNode<Task>? node = RunningTasks.First;
                while(node is not null)
                {
                    var val = node.Value;
                    if(val.IsCompleted)
                    {
                        RemovalQueue.Enqueue(node);
                        await val;
                    }
                    node = node.Next;
                }

                while (RemovalQueue.Count > 0)
                {
                    RunningTasks.Remove(RemovalQueue.Dequeue());
                    ParallelizationSemaphore.Release();
                }
            }
        }

        public static Task<long> CheckDirectorySize()
            => Task.Run(static () => new DirectoryInfo(SavePath).EnumerateFiles("*.*", SearchOption.AllDirectories).Sum(fi => fi.Length));

        public static string GenLink()
        {
            var sb = new StringBuilder(BaseUrl.Length + 6).Append(BaseUrl);
            for (int i = 0; i < IdLength; i++)
                sb.Append(CharPool[Rand.Next(0, CharPoolEnd)]);
            return sb.ToString();
        }

        public static async Task Fetch(string link)
        {
            var htmldoc = await Html.LoadFromWebAsync(link);
            string? url = htmldoc.DocumentNode.SelectSingleNode("/html/body/div[3]/div/img")?.GetAttributeValue<string>("src", null);
            if (url is null or Except)
                return;

            var uri = new Uri(url);
            string filename = uri.LocalPath.Replace("/", "");
            Console.WriteLine($"Writing new file to {filename}");

            Stream? input = null;
            FileStream? fs = null;
            try
            {
                fs = new(Path.Combine(SavePath, filename), FileMode.Create, FileAccess.Write, FileShare.None);
                input = await Http.GetStreamAsync(uri);
                await input.CopyToAsync(fs);
            }
            catch(Exception e)
            {
                Console.WriteLine($"Problem downloading file: {e.GetType().Name}: {e.Message}");
                return;
            }
            finally
            {
                input?.Dispose();
                fs?.Dispose();
            }
        }
    }
}