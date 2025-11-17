using System;
using System.IO;
using System.Windows;

namespace ShardOfEternisLauncher
{
    public partial class App : Application
    {
        private string LogPath => Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "ShardOfEternisGame", "launcher.log");

        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);
            try
            {
                var w = new MainWindow();
                w.Show();
            }
            catch (Exception ex)
            {
                SafeLog("Startup exception: " + ex);
                MessageBox.Show("Erreur au démarrage:\n" + ex, "Shard of Eternis Launcher", MessageBoxButton.OK, MessageBoxImage.Error);
                Shutdown(-1);
            }
        }

        private void SafeLog(string msg)
        {
            try
            {
                Directory.CreateDirectory(Path.GetDirectoryName(LogPath));
                File.AppendAllText(LogPath, DateTime.Now.ToString("O") + " | " + msg + "\n");
            }
            catch { }
        }
    }
}