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
    public enum LauncherState
    {
        Loading,
        Play,
        Update,
        Install
    }

    public partial class MainWindow : Window
    {
        private readonly string GAME_EXE_NAME = "ShardOfEternis.exe";
        private string GAME_INSTALL_PATH;
        private LauncherConfig config;
        private readonly HttpClient httpClient = new HttpClient();

        private LauncherState _currentState = LauncherState.Loading;
        private ReleaseInfo _latestRelease;

        public MainWindow()
        {
            InitializeComponent();
            GAME_INSTALL_PATH = ResolveDefaultInstallPath();
            InstallPathBox.Text = GAME_INSTALL_PATH;
            // L'image de fond est maintenant gérée directement par le XAML via les ressources
            LoadConfig();
            httpClient.DefaultRequestHeaders.UserAgent.ParseAdd("ShardOfEternisLauncher/1.0");
            _ = CheckForLauncherUpdateAsync(); // Check launcher update first
            _ = InitializeVersionAsync();
        }

        private async Task CheckForLauncherUpdateAsync()
        {
            try
            {
                var owner = config?.RepoOwner;
                var repo = config?.RepoName;
                if (string.IsNullOrWhiteSpace(owner) || string.IsNullOrWhiteSpace(repo)) return;

                // On vérifie la dernière release (peut être le jeu OU le launcher)
                var url = $"https://api.github.com/repos/{owner}/{repo}/releases/latest";
                var json = await httpClient.GetStringAsync(url);
                using var doc = JsonDocument.Parse(json);
                var root = doc.RootElement;
                
                var tag = root.TryGetProperty("tag_name", out var t) ? t.GetString() : "";
                
                // On cherche un asset nommé "ShardOfEternisLauncher.exe"
                string launcherUrl = null;
                if (root.TryGetProperty("assets", out var assets) && assets.ValueKind == JsonValueKind.Array)
                {
                    foreach (var a in assets.EnumerateArray())
                    {
                        var n = a.TryGetProperty("name", out var nn) ? nn.GetString() : "";
                        var u = a.TryGetProperty("browser_download_url", out var bu) ? bu.GetString() : "";
                        if (!string.IsNullOrEmpty(n) && n.Equals("ShardOfEternisLauncher.exe", StringComparison.OrdinalIgnoreCase))
                        {
                            launcherUrl = u;
                            break;
                        }
                    }
                }

                if (string.IsNullOrEmpty(launcherUrl)) return;

                // Comparaison de version simple : on suppose que le tag correspond à la version du launcher SI un exe est présent
                // Attention : Si on release une version du jeu v1.5 sans changer le launcher, et que le launcher actuel est v1.0
                // Il faut s'assurer que le tag v1.5 contient bien le launcher v1.5 (ou v1.0 repackagé).
                // Pour faire simple : Si "ShardOfEternisLauncher.exe" est présent dans la release, on compare le tag avec la version locale.
                
                var currentVersion = System.Reflection.Assembly.GetExecutingAssembly().GetName().Version;
                // Nettoyage du tag (ex: "v1.0.2" -> "1.0.2")
                var cleanTag = tag.TrimStart('v', 'V');
                
                if (Version.TryParse(cleanTag, out var remoteVersion))
                {
                    if (remoteVersion > currentVersion)
                    {
                        var res = MessageBox.Show($"Une nouvelle version du Launcher ({tag}) est disponible.\nVoulez-vous la télécharger maintenant ?", "Mise à jour Launcher", MessageBoxButton.YesNo, MessageBoxImage.Information);
                        if (res == MessageBoxResult.Yes)
                        {
                            await PerformLauncherUpdate(launcherUrl);
                        }
                    }
                }
            }
            catch { }
        }

        private async Task PerformLauncherUpdate(string url)
        {
            try
            {
                StatusLabel.Text = "Mise à jour du launcher...";
                ActionButton.IsEnabled = false;
                
                var tmpExe = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Launcher.new.exe");
                using (var s = await httpClient.GetStreamAsync(url))
                using (var f = File.Create(tmpExe))
                {
                    await s.CopyToAsync(f);
                }

                // Script de mise à jour
                var batchPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "update_launcher.bat");
                var currentExe = Process.GetCurrentProcess().MainModule.FileName;
                var exeName = Path.GetFileName(currentExe);
                
                var cmds = new[]
                {
                    "@echo off",
                    "timeout /t 2 /nobreak > nul",
                    $"del \"{exeName}\"",
                    $"move /y \"Launcher.new.exe\" \"{exeName}\"",
                    $"start \"\" \"{exeName}\"",
                    "del \"%~f0\""
                };
                
                File.WriteAllLines(batchPath, cmds);

                Process.Start(new ProcessStartInfo
                {
                    FileName = batchPath,
                    UseShellExecute = true,
                    CreateNoWindow = true
                });

                Application.Current.Shutdown();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erreur mise à jour launcher: " + ex.Message);
                StatusLabel.Text = "Erreur update launcher.";
                ActionButton.IsEnabled = true;
            }
        }

        private string ResolveDefaultInstallPath()
        {
            var exeDir = AppDomain.CurrentDomain.BaseDirectory;
            return exeDir;
        }

        // --- Gestion de la fenêtre Custom (Déplacement, Fermeture, Réduction) ---
        private void Window_MouseLeftButtonDown(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            if (e.ButtonState == System.Windows.Input.MouseButtonState.Pressed)
            {
                this.DragMove();
            }
        }

        private void CloseButton_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        private void MinimizeButton_Click(object sender, RoutedEventArgs e)
        {
            this.WindowState = WindowState.Minimized;
        }
        // -----------------------------------------------------------------------

        private async void ActionButton_Click(object sender, RoutedEventArgs e)
        {
            if (_currentState == LauncherState.Play)
            {
                PlayGame();
            }
            else if (_currentState == LauncherState.Update || _currentState == LauncherState.Install)
            {
                await UpdateGameAsync();
            }
        }

        private void PlayGame()
        {
            try
            {
                // Synchroniser le chemin depuis le champ si valide
                var inputPath = InstallPathBox.Text?.Trim();
                if (!string.IsNullOrWhiteSpace(inputPath) && Directory.Exists(inputPath))
                {
                    GAME_INSTALL_PATH = inputPath;
                    config.InstallPath = GAME_INSTALL_PATH;
                    SaveConfig(config);
                }
                StopRunningGame();
                SyncDataFiles();
                if (!EnsureInstallPathSelected()) return;
                // Localiser l'exécutable si nécessaire
                var exePath = Path.Combine(GAME_INSTALL_PATH, GAME_EXE_NAME);
                if (!File.Exists(exePath))
                {
                    var located = LocateGameExePath();
                    if (!string.IsNullOrEmpty(located))
                    {
                        exePath = Path.Combine(GAME_INSTALL_PATH, located);
                    }
                }
                if (!File.Exists(exePath))
                {
                    MessageBox.Show("Exécutable introuvable: " + exePath, "Shard of Eternis Launcher", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }
                var p = new Process();
                p.StartInfo.FileName = exePath;
                p.StartInfo.WorkingDirectory = GAME_INSTALL_PATH;
                p.Start();
                this.WindowState = WindowState.Minimized; // Réduire le launcher quand le jeu se lance
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erreur: \n" + ex.Message, "Shard of Eternis Launcher", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private async Task UpdateGameAsync()
        {
            // Synchroniser le chemin depuis le champ si valide
            var inputPath = InstallPathBox.Text?.Trim();
            if (!string.IsNullOrWhiteSpace(inputPath) && Directory.Exists(inputPath))
            {
                GAME_INSTALL_PATH = inputPath;
                config.InstallPath = GAME_INSTALL_PATH;
                SaveConfig(config);
            }
            if (!EnsureInstallPathSelected()) { StatusLabel.Text = "Installation annulée."; return; }
            
            StatusLabel.Text = "Recherche des mises à jour…";
            // Désactiver le bouton pendant l'update
            ActionButton.IsEnabled = false;
            ActionButton.Content = "EN COURS...";

            var latest = _latestRelease ?? await GetLatestReleaseAsync();
            if (latest == null)
            {
                StatusLabel.Text = "Aucune mise à jour disponible ou configuration absente.";
                ActionButton.IsEnabled = true;
                UpdateActionButtonState();
                return;
            }
            var assetUrl = latest.AssetUrl;
            if (string.IsNullOrEmpty(assetUrl))
            {
                StatusLabel.Text = "Aucun paquet de mise à jour trouvé pour la release.";
                ActionButton.IsEnabled = true;
                UpdateActionButtonState();
                return;
            }

            var tmp = Path.Combine(Path.GetTempPath(), "soe_update.zip");
            try
            {
                // Afficher la barre de progression
                ProgressArea.Visibility = Visibility.Visible;
                DownloadProgressBar.Value = 0;
                ProgressText.Text = "0%";

                using (var response = await httpClient.GetAsync(assetUrl, HttpCompletionOption.ResponseHeadersRead))
                {
                    response.EnsureSuccessStatusCode();
                    var totalBytes = response.Content.Headers.ContentLength ?? -1L;
                    using (var s = await response.Content.ReadAsStreamAsync())
                    using (var f = File.Create(tmp))
                    {
                        var buffer = new byte[8192];
                        var totalRead = 0L;
                        var isMoreToRead = true;
                        
                        // Variables pour le calcul de vitesse
                        var stopwatch = Stopwatch.StartNew();
                        var lastUpdate = stopwatch.ElapsedMilliseconds;
                        var lastBytes = 0L;

                        do
                        {
                            var read = await s.ReadAsync(buffer, 0, buffer.Length);
                            if (read == 0)
                            {
                                isMoreToRead = false;
                            }
                            else
                            {
                                await f.WriteAsync(buffer, 0, read);
                                totalRead += read;

                                var now = stopwatch.ElapsedMilliseconds;
                                if (now - lastUpdate > 500 || totalRead == totalBytes) // Mise à jour toutes les 500ms
                                {
                                    var elapsedSec = (now - lastUpdate) / 1000.0;
                                    if (elapsedSec > 0)
                                    {
                                        var bytesDiff = totalRead - lastBytes;
                                        var speed = bytesDiff / elapsedSec; // octets par seconde
                                        
                                        SpeedText.Text = FormatSpeed(speed);
                                        
                                        if (totalBytes != -1 && speed > 0)
                                        {
                                            var remainingBytes = totalBytes - totalRead;
                                            var remainingSec = remainingBytes / speed;
                                            TimeLeftText.Text = $"~{FormatTime(remainingSec)}";
                                        }
                                        
                                        lastUpdate = now;
                                        lastBytes = totalRead;
                                    }
                                }

                                if (totalBytes != -1)
                                {
                                    var progress = (double)totalRead / totalBytes * 100;
                                    DownloadProgressBar.Value = progress;
                                    ProgressText.Text = $"{(int)progress}%";
                                }
                                else
                                {
                                    // Si taille inconnue, on affiche juste les Mo téléchargés
                                    ProgressText.Text = $"{totalRead / 1024 / 1024} Mo";
                                }
                            }
                        }
                        while (isMoreToRead);
                        stopwatch.Stop();
                    }
                }
                
                StatusLabel.Text = "Installation...";
                await Task.Run(() => System.IO.Compression.ZipFile.ExtractToDirectory(tmp, GAME_INSTALL_PATH, true));
                
                // Ecrire la version installée
                var versionFile = Path.Combine(GAME_INSTALL_PATH, "version.txt");
                await File.WriteAllTextAsync(versionFile, latest.Tag);

                StatusLabel.Text = "Jeu à jour !";
                
                // Rafraichir l'état
                _currentState = LauncherState.Play;
                UpdateActionButtonState();
            }
            catch (Exception ex)
            {
                StatusLabel.Text = "Erreur mise à jour: " + ex.Message;
                ActionButton.IsEnabled = true;
                ActionButton.Content = "RÉESSAYER";
            }
            finally
            {
                ProgressArea.Visibility = Visibility.Collapsed;
                try { if (File.Exists(tmp)) File.Delete(tmp); } catch { }
            }
        }

        private void UpdateActionButtonState()
        {
            switch (_currentState)
            {
                case LauncherState.Loading:
                    ActionButton.Content = "CHARGEMENT...";
                    ActionButton.IsEnabled = false;
                    ActionButton.Background = new SolidColorBrush(Color.FromRgb(85, 85, 85)); // Gris
                    break;
                case LauncherState.Play:
                    ActionButton.Content = "JOUER";
                    ActionButton.IsEnabled = true;
                    ActionButton.Background = new SolidColorBrush(Color.FromRgb(34, 139, 34)); // Vert
                    break;
                case LauncherState.Update:
                    ActionButton.Content = "METTRE À JOUR";
                    ActionButton.IsEnabled = true;
                    ActionButton.Background = new SolidColorBrush(Color.FromRgb(0, 120, 215)); // Bleu
                    break;
                case LauncherState.Install:
                    ActionButton.Content = "INSTALLER";
                    ActionButton.IsEnabled = true;
                    ActionButton.Background = new SolidColorBrush(Color.FromRgb(0, 120, 215)); // Bleu
                    break;
            }
        }

        private void SettingsButton_Click(object sender, RoutedEventArgs e)
        {
            var w = new SettingsWindow(config, SaveConfig);
            w.Owner = this;
            w.ShowDialog();
            InstallPathBox.Text = config.InstallPath ?? GAME_INSTALL_PATH;
        }

        private void DiscordButton_Click(object sender, RoutedEventArgs e)
        {
            OpenUrl(config.DiscordUrl);
        }

        private void WebsiteButton_Click(object sender, RoutedEventArgs e)
        {
            OpenUrl(config.WebsiteUrl);
        }

        private void OpenUrl(string url)
        {
            try
            {
                Process.Start(new ProcessStartInfo
                {
                    FileName = url,
                    UseShellExecute = true
                });
            }
            catch { }
        }

        private string FormatSpeed(double bytesPerSecond)
        {
            if (bytesPerSecond < 1024) return $"{bytesPerSecond:F0} o/s";
            if (bytesPerSecond < 1024 * 1024) return $"{bytesPerSecond / 1024:F1} Ko/s";
            return $"{bytesPerSecond / 1024 / 1024:F1} Mo/s";
        }

        private string FormatTime(double seconds)
        {
            if (seconds < 60) return $"{seconds:F0}s";
            if (seconds < 3600) return $"{(int)seconds / 60}m {(int)seconds % 60}s";
            return $"{(int)seconds / 3600}h {((int)seconds % 3600) / 60}m";
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
            if (string.IsNullOrWhiteSpace(config.DiscordUrl)) config.DiscordUrl = "https://discord.gg/SysVaSgs9Y";
            if (string.IsNullOrWhiteSpace(config.WebsiteUrl)) config.WebsiteUrl = "https://github.com/Witherproduction/shard-of-eternis";
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
            _currentState = LauncherState.Loading;
            UpdateActionButtonState();

            // 1. Lire la version locale
            string localVersion = null;
            var versionFile = Path.Combine(GAME_INSTALL_PATH, "version.txt");
            if (File.Exists(versionFile))
            {
                localVersion = (await File.ReadAllTextAsync(versionFile)).Trim();
                VersionLabel.Text = "Version locale: " + localVersion;
            }
            else
            {
                VersionLabel.Text = "Jeu non détecté";
            }

            // 2. Vérifier GitHub
            _latestRelease = await GetLatestReleaseAsync();
            
            if (_latestRelease == null)
            {
                StatusLabel.Text = "Impossible de vérifier les mises à jour.";
                PatchNoteText.Text = "Impossible de récupérer les notes de mise à jour.";
                // Si on a le jeu, on laisse jouer quand même
                if (localVersion != null && File.Exists(Path.Combine(GAME_INSTALL_PATH, GAME_EXE_NAME)))
                {
                    _currentState = LauncherState.Play;
                }
                else
                {
                    _currentState = LauncherState.Install; // Ou erreur
                    ActionButton.IsEnabled = false; // Bloquer si on peut rien faire
                }
            }
            else
            {
                // Afficher le patch note
                PatchNoteText.Text = string.IsNullOrEmpty(_latestRelease.Body) ? "Aucune note de mise à jour disponible." : _latestRelease.Body;

                // Comparer
                if (localVersion == null)
                {
                    _currentState = LauncherState.Install;
                    StatusLabel.Text = "Prêt à installer : " + _latestRelease.Tag;
                }
                else if (localVersion != _latestRelease.Tag)
                {
                    _currentState = LauncherState.Update;
                    StatusLabel.Text = "Mise à jour disponible : " + _latestRelease.Tag;
                }
                else
                {
                    _currentState = LauncherState.Play;
                    StatusLabel.Text = "Jeu à jour.";
                }
            }
            
            UpdateActionButtonState();
        }

        private async Task<ReleaseInfo> GetLatestReleaseAsync()
        {
            var owner = config?.RepoOwner;
            var repo = config?.RepoName;
            if (string.IsNullOrWhiteSpace(owner) || string.IsNullOrWhiteSpace(repo)) return null;
            try
            {
                var url = $"https://api.github.com/repos/{owner}/{repo}/releases?per_page=20";
                var json = await httpClient.GetStringAsync(url);
                using var doc = JsonDocument.Parse(json);
                if (doc.RootElement.ValueKind != JsonValueKind.Array) return null;
                JsonElement best = default;
                DateTime bestDate = DateTime.MinValue;
                foreach (var rel in doc.RootElement.EnumerateArray())
                {
                    var draft = rel.TryGetProperty("draft", out var d) && d.ValueKind == JsonValueKind.True;
                    var prerelease = rel.TryGetProperty("prerelease", out var p) && p.ValueKind == JsonValueKind.True;
                    if (draft || prerelease) continue;
                    var publishedAt = rel.TryGetProperty("published_at", out var pa) && pa.ValueKind == JsonValueKind.String ? DateTime.TryParse(pa.GetString(), out var dt) ? dt : DateTime.MinValue : DateTime.MinValue;
                    if (publishedAt > bestDate) { bestDate = publishedAt; best = rel; }
                }
                if (best.ValueKind == JsonValueKind.Undefined) return null;
                var tag = best.TryGetProperty("tag_name", out var tn) && tn.ValueKind == JsonValueKind.String ? tn.GetString() : "";
                var body = best.TryGetProperty("body", out var b) && b.ValueKind == JsonValueKind.String ? b.GetString() : "Aucune note de mise à jour disponible.";
                string assetUrl = GetBestAssetUrl(best);
                return new ReleaseInfo { Tag = tag ?? "", AssetUrl = assetUrl ?? "", Body = body };
            }
            catch { return null; }
        }

        private string GetBestAssetUrl(JsonElement release)
        {
            if (release.TryGetProperty("assets", out var assets) && assets.ValueKind == JsonValueKind.Array)
            {
                string anyZip = null;
                string anyAsset = null;
                foreach (var a in assets.EnumerateArray())
                {
                    var n = a.TryGetProperty("name", out var nn) && nn.ValueKind == JsonValueKind.String ? nn.GetString() : "";
                    var u = a.TryGetProperty("browser_download_url", out var bu) && bu.ValueKind == JsonValueKind.String ? bu.GetString() : "";
                    if (string.IsNullOrEmpty(u)) continue;
                    if (!string.IsNullOrEmpty(n))
                    {
                        if (n.IndexOf("windows", StringComparison.OrdinalIgnoreCase) >= 0 && n.EndsWith(".zip", StringComparison.OrdinalIgnoreCase)) return u;
                        if (anyZip == null && n.EndsWith(".zip", StringComparison.OrdinalIgnoreCase)) anyZip = u;
                    }
                    if (anyAsset == null) anyAsset = u;
                }
                return anyZip ?? anyAsset;
            }
            return null;
        }

        private string LocateGameExePath()
        {
            try
            {
                var exeFiles = Directory.GetFiles(GAME_INSTALL_PATH, "*.exe", SearchOption.AllDirectories);
                string best = null;
                foreach (var f in exeFiles)
                {
                    var name = Path.GetFileName(f).ToLowerInvariant();
                    if (name.Contains("launcher")) continue;
                    if (name.Contains("shardofeternis"))
                    {
                        var rel = MakeRelativePath(GAME_INSTALL_PATH, f);
                        if (best == null || rel.Length < best.Length) best = rel;
                    }
                }
                // Si aucune correspondance stricte, prendre un exécutable au hasard (hors launcher)
                if (best == null)
                {
                    foreach (var f in exeFiles)
                    {
                        var name = Path.GetFileName(f).ToLowerInvariant();
                        if (name.Contains("launcher")) continue;
                        var rel = MakeRelativePath(GAME_INSTALL_PATH, f);
                        best = rel; break;
                    }
                }
                return best;
            }
            catch { return null; }
        }

        private string MakeRelativePath(string baseDir, string fullPath)
        {
            try
            {
                var uBase = new Uri(Path.GetFullPath(baseDir).TrimEnd(Path.DirectorySeparatorChar) + Path.DirectorySeparatorChar);
                var uFull = new Uri(Path.GetFullPath(fullPath));
                var rel = Uri.UnescapeDataString(uBase.MakeRelativeUri(uFull).ToString().Replace('/', Path.DirectorySeparatorChar));
                return rel;
            }
            catch { return fullPath; }
        }

        private bool EnsureInstallPathSelected()
        {
            try
            {
                // Si l'utilisateur a saisi un chemin valide dans la boîte, l'utiliser et persister
                var typed = InstallPathBox.Text?.Trim();
                if (!string.IsNullOrWhiteSpace(typed) && Directory.Exists(typed))
                {
                    GAME_INSTALL_PATH = typed;
                    config.InstallPath = GAME_INSTALL_PATH;
                    SaveConfig(config);
                }

                var exePath = Path.Combine(GAME_INSTALL_PATH ?? "", GAME_EXE_NAME);
                if (string.IsNullOrWhiteSpace(GAME_INSTALL_PATH) || !Directory.Exists(GAME_INSTALL_PATH))
                {
                    var dlg = new System.Windows.Forms.FolderBrowserDialog();
                    dlg.Description = "Choisissez le dossier d’installation du jeu";
                    dlg.UseDescriptionForTitle = true;
                    if (Directory.Exists(InstallPathBox.Text)) dlg.SelectedPath = InstallPathBox.Text;
                    if (dlg.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                    {
                        InstallPathBox.Text = dlg.SelectedPath;
                        GAME_INSTALL_PATH = dlg.SelectedPath;
                        config.InstallPath = GAME_INSTALL_PATH;
                        SaveConfig(config);
                        return true;
                    }
                    return false;
                }
                return true;
            }
            catch { return false; }
        }

        private async Task AutoInstallIfNeededAsync()
        {
            var exePath = Path.Combine(GAME_INSTALL_PATH, GAME_EXE_NAME);
            if (File.Exists(exePath)) return;
            StatusLabel.Text = "Installation du jeu…";
            var latest = await GetLatestReleaseAsync();
            if (latest == null || string.IsNullOrEmpty(latest.AssetUrl))
            {
                StatusLabel.Text = "Aucune release trouvée.";
                return;
            }
            var tmp = Path.Combine(Path.GetTempPath(), "soe_install.zip");
            try
            {
                using (var s = await httpClient.GetStreamAsync(latest.AssetUrl))
                using (var f = File.Create(tmp))
                {
                    await s.CopyToAsync(f);
                }
                System.IO.Compression.ZipFile.ExtractToDirectory(tmp, GAME_INSTALL_PATH, true);
                StatusLabel.Text = "Installation terminée.";
                VersionLabel.Text = "Version: " + latest.Tag;
            }
            catch (Exception ex)
            {
                StatusLabel.Text = "Erreur installation: " + ex.Message;
            }
            finally
            {
                try { if (File.Exists(tmp)) File.Delete(tmp); } catch { }
            }
        }

        private class ReleaseInfo
        {
            public string Tag { get; set; }
            public string AssetUrl { get; set; }
            public string Body { get; set; }
        }

        public class LauncherConfig
        {
            public string InstallPath { get; set; }
            public string RepoOwner { get; set; }
            public string RepoName { get; set; }
            public string DiscordUrl { get; set; }
            public string WebsiteUrl { get; set; }
        }
    }
}