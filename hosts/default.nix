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
    bootloader-grub-bios = {
      system = [
        ../modules/common/bootloader-grub-bios.nix
      ];
    };
    bootloader-grub-uefi = {
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
        ../apps/impulse/impulse.nix
      ];
    };
    workstation = {
      home = [ ../apps/workstation/workstation.nix ];
    };
    niri = {
      system = [
        inputs.niri-nix.nixosModules.default
        ../apps/niri/default.nix
      ];
      home = [
        inputs.niri-nix.homeModules.default
        ../apps/niri/niri.nix
        ../apps/noctalia/noctalia.nix
        ../apps/autoscreen/autoscreen.nix
        ../apps/ghostty/ghostty.nix
      ];
    };
    niri-waybar = {
      system = [
        inputs.niri-nix.nixosModules.default
        ../apps/niri/default.nix
        ../apps/hyprlock/default.nix
      ];
      home = [
        inputs.niri-nix.homeModules.default
        ../apps/niri/niri.nix
        ../apps/hyprlock/hyprlock.nix
        ../apps/swayidle/swayidle.nix
        ../apps/autoscreen/autoscreen.nix
        ../apps/waybar/waybar.nix
        ../apps/tofi/tofi.nix
        ../apps/mako/mako.nix
        ../apps/gammastep/gammastep.nix
        ../apps/ghostty/ghostty.nix
      ];
    };
    gnome = {
      system = [
        ../apps/gnome/default.nix
      ];
      home = [
        ../apps/gnome/gnome.nix
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
    docker-homelab = {
      system = [
        ../apps/docker-homelab/default.nix
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
        inputs.agent-skills.homeManagerModules.default
        ../apps/workmux/workmux.nix
        ../apps/cursor/cursor.nix
        ../apps/opencode/opencode.nix
        ../apps/openskills/openskills.nix
        ../apps/pi/pi.nix
        ../apps/oh-my-pi/oh-my-pi.nix
        ../apps/oh-my-opencode/oh-my-opencode.nix
        ../apps/beads/beads.nix
        ../apps/hermes/hermes.nix
        ../apps/rtk/rtk.nix
      ];
    };
    zeroclaw = {
      home = [
        ../apps/zeroclaw/zeroclaw.nix
      ];
    };
    qbittorrent = {
      system = [
        ../apps/qbittorrent/default.nix
      ];
    };
    jj = {
      home = [
        ../apps/jj/jj.nix
      ];
    };
    mullvad = {
      system = [
        ../apps/mullvad/default.nix
      ];
      home = [ ../apps/mullvad/mullvad.nix ];
    };
    ollama = {
      system = [ ../apps/ollama/default.nix ];
      home = [ ../apps/ollama/ollama.nix ];
    };
    restic = {
      home = [ ../apps/restic/restic.nix ];
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
      # Using optionals is more efficient than if-then-else for list construction
      systemModules = lib.flatten (
        map (
          profile:
          lib.optionals (
            moduleProfiles ? ${profile} && moduleProfiles.${profile} ? system
          ) moduleProfiles.${profile}.system
        ) profiles
      );

      # Extract home-manager modules from profiles
      homeModules = lib.flatten (
        map (
          profile:
          lib.optionals (
            moduleProfiles ? ${profile} && moduleProfiles.${profile} ? home
          ) moduleProfiles.${profile}.home
        ) profiles
      );
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
        ../apps/symmetri/default.nix
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
                hostName
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
                ../apps/editorconfig/editorconfig.nix
                ../apps/helix/helix.nix
                ../apps/nnn/nnn.nix
                ../apps/yazi/yazi.nix
                ../apps/udiskie/udiskie.nix
                ../apps/mime/mime.nix
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
  p14sg6 = mkHost {
    hostName = "p14sg6";
    stateVersion = "26.05";
    profiles = [
      "laptop"
      "impermanence"
      "bootloader-systemd-boot"
      "personal"
      "workstation"
      "niri"
      "android-tools"
      "steam"
      "firefox"
      "chromium"
      "qutebrowser"
      "mpd"
      "python"
      "code-agents"
      "mullvad"
      "ollama"
      "restic"
      "sops"
    ];
    extraModules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen6
      {
        my.stylix.wallpaper = "abstract-light-rays";
        disko.mainDisk = "/dev/nvme0n1";
      }
      ../apps/boinc/default.nix
    ];
  };
  cf-qv1 = mkHost {
    hostName = "cf-qv1";
    stateVersion = "26.05";
    profiles = [
      "laptop"
      "impermanence"
      "bootloader-systemd-boot"
      "personal"
      "workstation"
      "niri"
      # "android-tools"
      "steam"
      "firefox"
      "chromium"
      "python"
      "code-agents"
      "sops"
    ];
    extraModules = [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-gpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      {
        my.stylix.wallpaper = "cf-qv1";
        disko.mainDisk = "/dev/nvme0n1";
      }
      ../modules/common/laptop-thermald.nix
      ../modules/common/screen-rotation.nix
      ../modules/hardware/throttled.nix
      ../hosts/cf-qv1/throttled.nix
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
      "workstation"
      "gnome"
      "steam"
      "firefox"
      "chromium"
      "python"
      "code-agents"
      "sops"
    ];
    extraModules = [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      ../modules/common/laptop-thermald.nix
      ../modules/common/screen-rotation.nix
      ../modules/hardware/throttled.nix
      ../hosts/x1yoga/throttled.nix
      {
        my.stylix.wallpaper = "purple-waves";
      }
    ];
  };
  latitude = mkHost {
    hostName = "latitude";
    stateVersion = "24.05";
    profiles = [
      "laptop"
      "bootloader-systemd-boot"
      "workstation"
      "niri"
      "python"
      "docker"
      "firefox"
      "code-agents"
      "pycharm"
      "jj"
    ];
    extraModules = [
      inputs.nixos-hardware.nixosModules.dell-latitude-7420
      ../modules/common/laptop-thermald.nix
      ../modules/hardware/throttled.nix
      ../hosts/latitude/throttled.nix
      ../modules/common/printing.nix
      {
        my.stylix.wallpaper = "hk-plant";
      }
    ];
  };
  sg13 = mkHost {
    hostName = "sg13";
    stateVersion = "24.11";
    profiles = [
      "personal"
      "workstation"
      "bootloader-grub-uefi"
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
      ../modules/hardware/hid-tmff2.nix
      {
        my.stylix.wallpaper = "nyc-425-park-avenue";
      }
      (_: {
        hardware.hid-tmff2.enable = true;
      })
    ];
  };
  nixos-kimsufi-01 = mkHost {
    hostName = "nixos-kimsufi-01";
    stateVersion = "25.11";
    profiles = [
      "bootloader-grub-bios"
      "openssh-server"
      "qbittorrent"
    ];
  };
  nixos-kimsufi-02 = mkHost {
    hostName = "nixos-kimsufi-02";
    stateVersion = "25.11";
    profiles = [
      "bootloader-grub-bios"
      "openssh-server"
      "zeroclaw"
    ];
  };
  nixos-kimsufi-03 = mkHost {
    hostName = "nixos-kimsufi-03";
    stateVersion = "25.11";
    profiles = [
      "bootloader-grub-bios"
      "openssh-server"
      "docker-homelab"
    ];
    extraModules = [
      {
        services.docker-homelab = {
          enable = true;
          domain = "dbeley.ovh";
          letsencrypt_email = "admin@dbeley.ovh";
        };
      }
    ];
  };
}
