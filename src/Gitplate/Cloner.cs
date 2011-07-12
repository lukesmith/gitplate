using System;
using System.Diagnostics;
using System.IO;

namespace Gitplate
{
    public class Cloner : IDisposable
    {
        private readonly string repositoryPath;
        private readonly string targetPath;
        private string repositoryClone;

        public Cloner(string repositoryPath, string targetPath)
        {
            this.repositoryPath = repositoryPath;
            this.targetPath = targetPath;
        }

        public void Dispose()
        {
            FileHelpers.DeleteDirectory(this.repositoryClone);
        }

        public void Clone()
        {
            this.repositoryClone = Path.Combine(@"c:\temp\", Path.GetRandomFileName());
            CloneToTemporaryDirectory(this.repositoryPath, this.repositoryClone);
            this.RemoveGitDirectory();
            this.CopyToTargetDir();
        }

        private static void CloneToTemporaryDirectory(string repository, string target)
        {
            var process = new Process
                {
                    StartInfo =
                        {
                            UseShellExecute = false,
                            FileName = @"C:\Program Files (x86)\Git\bin\git",
                            Arguments = string.Format("clone {0} {1}", repository, target),
                            CreateNoWindow = true,
                            RedirectStandardOutput = true
                        }
                };
            process.Start();
            process.WaitForExit();
        }

        private void CopyToTargetDir()
        {
            FileHelpers.DeleteDirectory(this.targetPath);
            FileHelpers.CopyDirectory(this.repositoryPath, this.targetPath);
        }

        private void RemoveGitDirectory()
        {
            FileHelpers.DeleteDirectory(Path.Combine(this.repositoryPath, ".git"));
        }
    }
}