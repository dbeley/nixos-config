{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.kp.database = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/Nextcloud/10-19_Documents/11_Keepass/11.11_Courant/Mots de passe.kdbx";
    description = ''
      KeePass database the kp front-end (tofi + keepassxc-cli) reads from.
      Loaded on hosts that opt in through extraHomeModules.
    '';
  };

  config = {
    home.packages = [
      (import ./package.nix {
        inherit pkgs;
        database = config.my.kp.database;
      })
    ];

    # The shared niri config spawns the KeePassXC GUI on Mod+N; on hosts that
    # import this module the overlay flow replaces it.
    wayland.windowManager.niri.settings.binds = {
      "Mod+N".spawn = lib.mkForce [ "kp" ];
      "Mod+Shift+N".spawn = lib.mkForce [
        "kp"
        "--actions"
      ];
    };
  };
}
