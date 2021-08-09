using RssFeedParser;
using RssFeedParser.Models;
using System;
using System.Threading.Tasks;
using System.Linq;

namespace RssFeedParser_Test
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var rssFeedParser = new FeedParser();
            RssFeed feed = await rssFeedParser.ParseFeed("https://beta.erai-raws.info/feed/?res=720p&type=magnet&subs[]=us");

            int i = 0;
            P("Showing articles");
            foreach (var x in feed.Articles)
                P($"Article {++i}: *{x.Title}* \nPublished on {x.Published:G}\nCategories: {string.Join(", ", x.Categories.Select(y => y.Name))}\nLink: {x.Link}\n\n{x.Content}\n");

            void P(object o) => Console.WriteLine(o);
        }
    }
}
