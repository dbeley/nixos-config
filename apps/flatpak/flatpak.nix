{ lib, ... }:
{

  # Add a new remote. Keep the default one (flathub)
  services = {
    flatpak = {
      remotes = lib.mkOptionDefault [
        {
          name = "flathub-beta";
          location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        }
      ];
      update.auto.enable = false;
      uninstallUnmanaged = false;
    };
  };

}
