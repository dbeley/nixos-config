{ user, ... }:
{
  home.persistence."/persistent/home/${user}" = {
    directories = [
      "Documents"
      "Musique"
      "Nextcloud"
      "Téléchargements"
      "nfs"
      ".gnupg"
      ".ssh"
      ".config/chromium"
      ".config/gtk-3.0"
      ".config/keepassxc"
      ".config/libreoffice/4/user/pack"
      ".config/mpdscrobble"
      ".config/supersonic"
      ".config/Nextcloud"
      ".local/share/direnv"
      # ".local/share/fish"
      ".local/share/flatpak"
      ".local/share/keyrings"
      ".local/share/mpd"
      # ".local/share/zoxide"
      ".mozilla/firefox/david"
      ".mozilla/native-messaging-hosts"
      # ".cache/mozilla/firefox/david"
      # ".cache/keepassxc"
      ".cache/tealdeer/tldr-pages"
      ".var/app"
    ];
    files = [
      # ".config/Nextcloud/cookies0.db"
      ".cache/keepassxc/keepassxc.ini"
      ".local/share/zoxide/db.zo"
      ".local/share/fish/fish_history"
      ".cache/tofi-compgen"
      ".local/state/tofi-history"
    ];
    allowOther = true;
  };
}
