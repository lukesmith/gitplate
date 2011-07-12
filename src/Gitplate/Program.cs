namespace Gitplate
{
    public class Program
    {
        private static void Main(string[] args)
        {
            var arguments = Args.Configuration.Configure<ConsoleArguments>().CreateAndBind(args);

            using (var cloner = new Cloner(arguments.Repository, arguments.TargetDir))
            {
                cloner.Clone();
            }
        }

        public class ConsoleArguments
        {
            public string Repository { get; set; }

            public string TargetDir { get; set; }

            public bool Commit { get; set; }
        }
    }
}
