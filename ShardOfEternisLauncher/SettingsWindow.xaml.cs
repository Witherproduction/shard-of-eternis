using System;
using System.IO;
using System.Windows;
using System.Windows.Forms;

namespace ShardOfEternisLauncher
{
    public partial class SettingsWindow : Window
    {
        private readonly MainWindow.LauncherConfig _config;
        private readonly Action<MainWindow.LauncherConfig> _onSave;

        public SettingsWindow(MainWindow.LauncherConfig config, Action<MainWindow.LauncherConfig> onSave)
        {
            InitializeComponent();
            _config = config ?? new MainWindow.LauncherConfig();
            _onSave = onSave;
            InstallPathText.Text = _config.InstallPath ?? string.Empty;
            RepoOwnerText.Text = _config.RepoOwner ?? string.Empty;
            RepoNameText.Text = _config.RepoName ?? string.Empty;
        }

        private void BrowseInstallPath_Click(object sender, RoutedEventArgs e)
        {
            using (var dialog = new FolderBrowserDialog())
            {
                dialog.Description = "Choisissez le dossier d’installation du jeu";
                dialog.UseDescriptionForTitle = true;
                if (Directory.Exists(InstallPathText.Text)) dialog.SelectedPath = InstallPathText.Text;
                if (dialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                {
                    InstallPathText.Text = dialog.SelectedPath;
                }
            }
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            _config.InstallPath = string.IsNullOrWhiteSpace(InstallPathText.Text) ? null : InstallPathText.Text.Trim();
            _config.RepoOwner = string.IsNullOrWhiteSpace(RepoOwnerText.Text) ? null : RepoOwnerText.Text.Trim();
            _config.RepoName = string.IsNullOrWhiteSpace(RepoNameText.Text) ? null : RepoNameText.Text.Trim();
            _onSave?.Invoke(_config);
            DialogResult = true;
            Close();
        }
    }
}