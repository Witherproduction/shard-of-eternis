using System;
using System.Diagnostics;
using System.IO;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;

namespace ShardOfEternisLauncher
{
    public partial class MainWindow : Window
    {
        private readonly string GAME_EXE_NAME = "ShardOfEternis.exe";
        private string GAME_INSTALL_PATH;
        private LauncherConfig config;
        private readonly HttpClient httpClient = new HttpClient();

        public MainWindow()
        {
            InitializeComponent();
            GAME_INSTALL_PATH = ResolveDefaultInstallPath();
            InstallPathBox.Text = GAME_INSTALL_PATH;
            SetBackgroundFromParentFolderImage();
            LoadConfig();
            httpClient.DefaultRequestHeaders.UserAgent.ParseAdd("ShardOfEternisLauncher/1.0");
            _ = InitializeVersionAsync();
        }

        private string ResolveDefaultInstallPath()
        {
            var exeDir = AppDomain.CurrentDomain.BaseDirectory;
            return exeDir;
        }

        private void BrowseInstallPath_Click(object sender, RoutedEventArgs e)
        {
            var dlg = new System.Windows.Forms.FolderBrowserDialog();
            dlg.Description = "Choisissez le dossier d’installation du jeu";
            dlg.UseDescriptionForTitle = true;
            if (Directory.Exists(InstallPathBox.Text)) dlg.SelectedPath = InstallPathBox.Text;
            if (dlg.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                InstallPathBox.Text = dlg.SelectedPath;
                GAME_INSTALL_PATH = dlg.SelectedPath;
            }
        }

        private void PlayButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                StopRunningGame();
                SyncDataFiles();
                var exePath = Path.Combine(GAME_INSTALL_PATH, GAME_EXE_NAME);
                if (!File.Exists(exePath))
                {
                    MessageBox.Show("Exécutable introuvable: " + exePath, "Shard of Eternis Launcher", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }
                var p = new Process();
                p.StartInfo.FileName = exePath;
                p.StartInfo.WorkingDirectory = GAME_INSTALL_PATH;
                p.Start();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erreur: \n" + ex.Message, "Shard of Eternis Launcher", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private async void UpdateButton_Click(object sender, RoutedEventArgs e)
        {
            StatusLabel.Text = "Recherche des mises à jour…";
            var latest = await GetLatestReleaseAsync();
            if (latest == null)
            {
                StatusLabel.Text = "Aucune mise à jour disponible ou configuration absente.";
                return;
            }
            var assetUrl = latest.AssetUrl;
            if (string.IsNullOrEmpty(assetUrl))
            {
                StatusLabel.Text = "Aucun paquet de mise à jour trouvé.";
                return;
            }
            var tmp = Path.Combine(Path.GetTempPath(), "soe_update.zip");
            try
            {
                using (var s = await httpClient.GetStreamAsync(assetUrl))
                using (var f = File.Create(tmp))
                {
                    await s.CopyToAsync(f);
                }
                System.IO.Compression.ZipFile.ExtractToDirectory(tmp, GAME_INSTALL_PATH, true);
                StatusLabel.Text = "Mise à jour installée.";
                VersionLabel.Text = "Version: " + latest.Tag;
            }
            catch (Exception ex)
            {
                StatusLabel.Text = "Erreur mise à jour: " + ex.Message;
            }
            finally
            {
                try { if (File.Exists(tmp)) File.Delete(tmp); } catch { }
            }
        }

        private void SettingsButton_Click(object sender, RoutedEventArgs e)
        {
            var w = new SettingsWindow(config, SaveConfig);
            w.Owner = this;
            w.ShowDialog();
            InstallPathBox.Text = config.InstallPath ?? GAME_INSTALL_PATH;
        }

        private void StopRunningGame()
        {
            try
            {
                foreach (var proc in Process.GetProcessesByName("ShardOfEternis"))
                {
                    try { proc.Kill(); proc.WaitForExit(500); } catch { }
                }
            }
            catch { }
        }

        private void SyncDataFiles()
        {
            try
            {
                var srcDir = Path.Combine(GAME_INSTALL_PATH, "datafiles");
                var saveDir = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "ShardOfEternis", "datafiles");
                Directory.CreateDirectory(saveDir);
                foreach (var file in new[] { "cards_database.json", "favorite_cards.json", "saved_decks.json" })
                {
                    var src = Path.Combine(srcDir, file);
                    var dst = Path.Combine(saveDir, file);
                    if (File.Exists(src))
                    {
                        File.Copy(src, dst, true);
                    }
                }
            }
            catch { }
        }

        private void SetBackgroundFromParentFolderImage()
        {
            try
            {
                var exeDir = new DirectoryInfo(AppDomain.CurrentDomain.BaseDirectory);
                // Tenter d'identifier le dossier du projet (accepte espace, underscore, tiret)
                DirectoryInfo dir = exeDir;
                DirectoryInfo projectRoot = null;
                while (dir != null)
                {
                    var name = dir.Name.ToLowerInvariant();
                    if (name == "shard of eternis" || name == "shard_of_eternis" || name == "shard-of-eternis")
                    {
                        projectRoot = dir;
                        break;
                    }
                    dir = dir.Parent;
                }

                // Si non trouvé, utiliser directement le parent du dossier contenant l'exe
                var searchRoot = projectRoot?.Parent ?? exeDir.Parent ?? exeDir;

                // Priorité aux fichiers nommés de manière explicite, sinon prendre la plus grande image
                var candidates = searchRoot.GetFiles("*.*");
                FileInfo chosen = null;
                // Noms préférés
                var preferred = new[] { "background", "bg", "launcher_bg", "wallpaper" };
                foreach (var f in candidates)
                {
                    var ext = f.Extension.ToLowerInvariant();
                    if (ext == ".png" || ext == ".jpg" || ext == ".jpeg" || ext == ".bmp")
                    {
                        var baseName = Path.GetFileNameWithoutExtension(f.Name).ToLowerInvariant();
                        if (Array.Exists(preferred, p => baseName.Contains(p))) { chosen = f; break; }
                        if (chosen == null || f.Length > chosen.Length) chosen = f;
                    }
                }
                if (chosen == null) return;
                var img = new BitmapImage();
                img.BeginInit();
                img.UriSource = new Uri(chosen.FullName, UriKind.Absolute);
                img.CacheOption = BitmapCacheOption.OnLoad;
                img.EndInit();
                var brush = new ImageBrush(img)
                {
                    Stretch = Stretch.UniformToFill,
                    AlignmentX = AlignmentX.Center,
                    AlignmentY = AlignmentY.Center
                };
                this.Background = brush;
            }
            catch { }
        }

        private void LoadConfig()
        {
            var path = GetConfigPath();
            if (File.Exists(path))
            {
                var json = File.ReadAllText(path);
                config = JsonSerializer.Deserialize<LauncherConfig>(json) ?? new LauncherConfig();
            }
            else
            {
                config = new LauncherConfig();
            }
            if (!string.IsNullOrWhiteSpace(config.InstallPath))
            {
                GAME_INSTALL_PATH = config.InstallPath;
            }
            if (string.IsNullOrWhiteSpace(config.RepoOwner)) config.RepoOwner = "Witherproduction";
            if (string.IsNullOrWhiteSpace(config.RepoName)) config.RepoName = "shard-of-eternis";
            SaveConfig(config);
        }

        private void SaveConfig(LauncherConfig cfg)
        {
            config = cfg ?? new LauncherConfig();
            var path = GetConfigPath();
            Directory.CreateDirectory(Path.GetDirectoryName(path));
            var json = JsonSerializer.Serialize(config);
            File.WriteAllText(path, json);
            if (!string.IsNullOrWhiteSpace(config.InstallPath)) GAME_INSTALL_PATH = config.InstallPath;
        }

        private string GetConfigPath()
        {
            var dir = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "ShardOfEternisGame");
            return Path.Combine(dir, "launcher.config.json");
        }

        private async Task InitializeVersionAsync()
        {
            var latest = await GetLatestReleaseAsync();
            if (latest != null) VersionLabel.Text = "Version: " + latest.Tag;
        }

        private async Task<ReleaseInfo> GetLatestReleaseAsync()
        {
            var owner = config?.RepoOwner;
            var repo = config?.RepoName;
            if (string.IsNullOrWhiteSpace(owner) || string.IsNullOrWhiteSpace(repo)) return null;
            try
            {
                var url = $"https://api.github.com/repos/{owner}/{repo}/releases/latest";
                var json = await httpClient.GetStringAsync(url);
                using var doc = JsonDocument.Parse(json);
                var root = doc.RootElement;
                var tag = root.TryGetProperty("tag_name", out var tn) ? tn.GetString() : "";
                string assetUrl = "";
                if (root.TryGetProperty("assets", out var assets) && assets.ValueKind == JsonValueKind.Array)
                {
                    foreach (var a in assets.EnumerateArray())
                    {
                        var n = a.TryGetProperty("name", out var nn) ? nn.GetString() : "";
                        var u = a.TryGetProperty("browser_download_url", out var bu) ? bu.GetString() : "";
                        if (!string.IsNullOrEmpty(n) && n.Contains("windows", StringComparison.OrdinalIgnoreCase) && n.EndsWith(".zip", StringComparison.OrdinalIgnoreCase))
                        {
                            assetUrl = u; break;
                        }
                        if (string.IsNullOrEmpty(assetUrl) && n.EndsWith(".zip", StringComparison.OrdinalIgnoreCase)) assetUrl = u;
                    }
                }
                return new ReleaseInfo { Tag = tag, AssetUrl = assetUrl };
            }
            catch { return null; }
        }

        private class ReleaseInfo
        {
            public string Tag { get; set; }
            public string AssetUrl { get; set; }
        }

        public class LauncherConfig
        {
            public string InstallPath { get; set; }
            public string RepoOwner { get; set; }
            public string RepoName { get; set; }
        }
    }
}