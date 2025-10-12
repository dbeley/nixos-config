{
  lib,
  inputs,
  user,
  ...
}:
let
  moduleProfiles = {
    laptop = {
      system = [
        ../modules/common/laptop.nix
        ../modules/common/fingerprint-scanner.nix
      ];
    };
    impermanence = {
      system = [
        inputs.disko.nixosModules.disko
        ../modules/disko/encrypted-btrfs-impermanence.nix
        inputs.impermanence.nixosModules.impermanence
        ../modules/impermanence/default.nix
      ];
    };
    bootloader-systemd-boot = {
      system = [
        ../modules/common/bootloader-systemd-boot.nix
      ];
    };
    bootloader-grub = {
      system = [
        ../modules/common/bootloader-grub-uefi.nix
      ];
    };
    sops = {
      system = [
        inputs.sops-nix.nixosModules.sops
        ../modules/sops/default.nix
      ];
      home = [
        inputs.sops-nix.homeManagerModules.sops
        ../modules/sops/sops.nix
      ];
    };
    openssh-server = {
      system = [
        ../modules/common/openssh-server.nix
      ];
    };
    personal = {
      home = [
        ../apps/ledger/ledger.nix
        ../apps/mpv/mpv.nix
        ../apps/nextcloud-client/nextcloud-client.nix
      ];
    };
    niri = {
      system = [
        ../apps/niri/default.nix
        ../apps/hyprlock/default.nix
      ];
      home = [
        inputs.niri.homeModules.niri
        inputs.niri.homeModules.stylix
        ../apps/niri/niri.nix
        ../apps/hyprlock/hyprlock.nix
        ../apps/hypridle/hypridle.nix
        ../apps/autoscreen/autoscreen.nix
        ../apps/waybar/waybar.nix
        ../apps/tofi/tofi.nix
        ../apps/mako/mako.nix
        ../apps/gammastep/gammastep.nix
        ../apps/kitty/kitty.nix
      ];
    };
    hyprland = {
      system = [
        ../apps/hyprland/default.nix
        ../apps/hyprlock/default.nix
      ];
      home = [
        inputs.hyprland.homeManagerModules.default
        ../apps/hyprland/hyprland.nix
        ../apps/hyprlock/hyprlock.nix
        ../apps/hypridle/hypridle.nix
        ../apps/autoscreen/autoscreen.nix
        ../apps/autoscreen-gaming/autoscreen-gaming.nix
        ../apps/waybar/waybar.nix
        ../apps/tofi/tofi.nix
        ../apps/mako/mako.nix
        ../apps/gammastep/gammastep.nix
        ../apps/kitty/kitty.nix
      ];
    };
    gnome = {
      system = [
        ../apps/gnome/default.nix
      ];
      home = [
        ../apps/gnome/gnome.nix
        # ../apps/autoscreen-gnome/autoscreen-gnome.nix
      ];
    };
    sway = {
      system = [
        ../apps/swaylock/default.nix
      ];
      home = [
        ../apps/sway/sway.nix
        ../apps/swaylock/swaylock.nix
        ../apps/waybar/waybar.nix
        ../apps/tofi/tofi.nix
        ../apps/mako/mako.nix
        ../apps/gammastep/gammastep.nix
        ../apps/autoscreen/autoscreen.nix
        ../apps/kitty/kitty.nix
      ];
    };
    steam = {
      system = [
        ../modules/common/xbox.nix
        ../apps/steam/default.nix
      ];
      home = [ ../apps/steam/steam.nix ];
    };
    docker = {
      system = [
        ../apps/docker/default.nix
      ];
    };
    podman = {
      system = [
        ../apps/podman/default.nix
      ];
    };
    firefox = {
      home = [ ../apps/firefox/firefox.nix ];
    };
    chromium = {
      home = [ ../apps/ungoogled-chromium/ungoogled-chromium.nix ];
    };
    mpd = {
      home = [
        ../apps/mpd/mpd.nix
        ../apps/mpdscrobble/mpdscrobble.nix
      ];
    };
    python = {
      home = [
        ../apps/direnv/direnv.nix
        ../apps/python/python.nix
      ];
    };
    neovim-nvf = {
      home = [
        inputs.nvf.homeManagerModules.default
        ../apps/neovim-nvf/neovim-nvf.nix
      ];
    };
    android-tools = {
      system = [
        ../apps/android/default.nix
      ];
    };
    vscode = {
      home = [
        ../apps/vscode/vscode.nix
      ];
    };
    qutebrowser = {
      home = [ ../apps/qutebrowser/qutebrowser.nix ];
    };
    emacs = {
      home = [ ../apps/emacs/emacs.nix ];
    };
    kakoune = {
      home = [ ../apps/kakoune/kakoune.nix ];
    };
    obs = {
      home = [ ../apps/obs/obs.nix ];
    };
    pycharm = {
      home = [ ../apps/pycharm/pycharm.nix ];
    };
    sunshine = {
      system = [ ../apps/sunshine/default.nix ];
    };
    moonlight = {
      home = [ ../apps/moonlight/moonlight.nix ];
    };
    code-agents = {
      home = [
        # ../apps/claude/claude.nix
        # ../apps/gemini/gemini.nix
        ../apps/codex/codex.nix
        ../apps/cursor/cursor.nix
      ];
    };
  };
  mkHost =
    {
      hostName,
      stateVersion,
      system ? "x86_64-linux",
      profiles ? [ ],
      extraModules ? [ ],
      extraHomeModules ? [ ],
      homeConfig ? ../hosts/${hostName}/home.nix,
    }:
    let
      # Extract system modules from profiles
      systemModules = lib.concatMap (
        profile:
        if moduleProfiles ? ${profile} && moduleProfiles.${profile} ? system then
          moduleProfiles.${profile}.system
        else
          [ ]
      ) profiles;

      # Extract home-manager modules from profiles
      homeModules = lib.concatMap (
        profile:
        if moduleProfiles ? ${profile} && moduleProfiles.${profile} ? home then
          moduleProfiles.${profile}.home
        else
          [ ]
      ) profiles;
    in
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          user
          inputs
          hostName
          stateVersion
          ;
      };
      modules = [
        ../modules/configuration.nix
        ../modules/overlays.nix
        ../modules/cachix/cachix.nix
        inputs.stylix.nixosModules.stylix
        ../apps/stylix/default.nix
        ../apps/udiskie/default.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit
                user
                inputs
                system
                stateVersion
                ;
              selectedProfiles = profiles;
            };
            users.${user} = {
              imports = [
                ../hosts/home-manager-common-config.nix
                ../apps/stylix/stylix.nix
                ../apps/git/git.nix
                ../apps/lazygit/lazygit.nix
                ../apps/fish/fish.nix
                ../apps/tmux/tmux.nix
                ../apps/helix/helix.nix
                ../apps/nnn/nnn.nix
                ../apps/yazi/yazi.nix
                ../apps/udiskie/udiskie.nix
                ../apps/mime/mime.nix
                # ../apps/imv/imv.nix
                ../apps/swayimg/swayimg.nix
                ../apps/bat/bat.nix
                ../apps/zoxide/zoxide.nix
                ../apps/zathura/zathura.nix
                ../apps/tealdeer/tealdeer.nix
                homeConfig
              ]
              ++ homeModules
              ++ extraHomeModules;
            };
          };
        }
        ../hosts/${hostName}/hardware-configuration.nix
      ]
      ++ systemModules
      ++ extraModules;
    };
in
{
  p14s = mkHost {
    hostName = "p14s";
    stateVersion = "25.05";
    profiles = [
      "laptop"
      "impermanence"
      "bootloader-systemd-boot"
      "personal"
      "niri"
      "android-tools"
      # "docker"
      "steam"
      "firefox"
      "chromium"
      "mpd"
      "python"
      "code-agents"
    ];
    extraModules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen4
      {
        my.stylix.wallpaper = "abstract-light-rays";
      }
    ];
  };
  x1yoga = mkHost {
    hostName = "x1yoga";
    stateVersion = "25.05";
    profiles = [
      "laptop"
      "impermanence"
      "bootloader-systemd-boot"
      "personal"
      "gnome"
      "steam"
      "firefox"
      "chromium"
      "python"
    ];
    extraModules = [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      ../modules/common/laptop-thermald.nix
      ../modules/common/screen-rotation.nix
      {
        my.stylix.wallpaper = "purple-waves";
      }
    ];
  };
  x13 = mkHost {
    hostName = "x13";
    stateVersion = "24.11";
    profiles = [
      "laptop"
      "impermanence"
      "bootloader-systemd-boot"
      "personal"
      "niri"
      "android-tools"
      "steam"
      "firefox"
      "chromium"
      "mpd"
      "python"
    ];
    extraModules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x13-amd
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      {
        my.stylix.wallpaper = "nyc-425-park-avenue";
      }
    ];
  };
  vaio = mkHost {
    hostName = "vaio";
    stateVersion = "25.05";
    profiles = [
      "laptop"
      "bootloader-systemd-boot"
      "personal"
      "sops"
      "niri"
      "steam"
      "android-tools"
      "firefox"
      "chromium"
      "mpd"
      "python"
      "obs"
      "code-agents"
    ];
    extraModules = [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-gpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      {
        my.stylix.wallpaper = "blue-planet";
      }
    ];
  };
  latitude = mkHost {
    hostName = "latitude";
    stateVersion = "24.05";
    profiles = [
      "laptop"
      "bootloader-systemd-boot"
      "niri"
      "python"
      "docker"
      # "neovim-nvf"
      "firefox"
      "vscode"
      "code-agents"
    ];
    extraModules = [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-gpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      ../modules/common/laptop-thermald.nix
      ../modules/common/printing.nix
      {
        my.stylix.wallpaper = "hk-plant";
      }
    ];
    extraHomeModules = [
      ../apps/pycharm-professional/pycharm.nix
    ];
  };
  letsnote = mkHost {
    hostName = "letsnote";
    stateVersion = "25.05";
    profiles = [
      "laptop"
      "impermanence"
      "bootloader-systemd-boot"
      "personal"
      "gnome"
      "steam"
      "firefox"
      "chromium"
      "python"
    ];
    extraModules = [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-gpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      {
        my.stylix.wallpaper = "blue-planet";
      }
      ../modules/common/laptop-thermald.nix
      ../modules/common/screen-rotation.nix
    ];
  };
  sg13 = mkHost {
    hostName = "sg13";
    stateVersion = "24.11";
    profiles = [
      "personal"
      "bootloader-grub"
      "openssh-server"
      "gnome"
      "steam"
      "firefox"
      "chromium"
      "python"
      "code-agents"
    ];
    extraModules = [
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
      (inputs.nixos-hardware + "/common/gpu/nvidia/ampere")
      ../apps/boinc/default.nix
      {
        my.stylix.wallpaper = "hk-plant";
      }
    ];
  };
  x61s = mkHost {
    hostName = "x61s";
    stateVersion = "22.11";
    profiles = [
      "laptop"
      "personal"
      "sway"
      "python"
      "steam"
      "mpd"
      "firefox"
      "chromium"
    ];
    extraModules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x200s
      ../modules/common/bootloader-grub-bios.nix
    ];
  };
  nixos-01 = mkHost {
    hostName = "nixos-01";
    stateVersion = "25.05";
    profiles = [
      "bootloader-grub"
      "openssh-server"
      "docker"
    ];
    extraModules = [
      ../hosts/nixos-01/default.nix
    ];
  };
}
