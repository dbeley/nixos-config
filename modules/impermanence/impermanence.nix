{ user, ... }:
{
  home.persistence."/persistent/home/${user}" = {
    directories = [
      "Documents"
      "Musique"
      "Nextcloud"
      "Téléchargements"
      "Games"
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
      ".local/share/flatpak"
      ".local/share/keyrings"
      ".local/share/mpd"
      ".mozilla/firefox/david"
      ".mozilla/native-messaging-hosts"
      ".cache/tealdeer/tldr-pages"
      ".var/app"
      ".config/heroic/GamesConfig"
      ".config/heroic/store"
      ".config/heroic/tools"
      ".config/heroic/gog_store"
      ".config/heroic/legendaryConfig"
      ".config/heroic/nile_config"
      ".local/share/Steam"
    ];
    files = [
      ".cache/keepassxc/keepassxc.ini"
      ".local/share/zoxide/db.zo"
      ".local/share/fish/fish_history"
      ".cache/tofi-compgen"
      ".local/state/tofi-history"
    ];
    allowOther = true;
  };
}
