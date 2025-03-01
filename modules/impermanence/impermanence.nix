{ user, ... }:
{
  home.persistence."/persistent/home/${user}" = {
    directories = [
      "Documents"
      "Musique"
      "Nextcloud"
      "Téléchargements"
      {
        directory = "nfs";
        method = "symlink";
      }
      {
        directory = ".local/share/Steam";
        # On a first install, disable symlink below then re-enable it after running Steam for the first time
        # cf. https://github.com/nix-community/impermanence/issues/165
        method = "symlink";
      }
      ".gnupg"
      ".ssh"
      ".local/share/keyrings"
      ".local/share/direnv"
      ".steam"
      ".mozilla/firefox/david"
      # ".cache/mozilla/firefox/david"
      ".config/chromium"
      ".local/share/mpd"
      ".config/Nextcloud"
      ".config/keepassxc"
      ".cache/keepassxc"
      ".local/share/fish"
      ".local/share/zoxide"
      ".config/mpdscrobble"
      ".config/supersonic"
    ];
    files = [
      # Doesn't work
      # ".config/Nextcloud/cookies0.db"
      # ".cache/keepassxc/keepassxc.ini"
      # ".local/share/zoxide/db.zo"
      # ".local/share/fish/fish_history"
      # ".cache/tofi-compgen"
    ];
    allowOther = true;
  };
}
