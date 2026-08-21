{
  lib,
  inputs,
  user,
  ...
}:
let
  # Public domain for the homelab services. Each service becomes
  # <service>.<domain>. Overridable per host via mkHost's `domain` param
  # (e.g. the llm-agents VM uses `agents.home.dbeley.ovh`).
  defaultDomain = "home.dbeley.ovh";
  moduleProfiles = {
    laptop = {
      system = [
        ../modules/common/laptop.nix
        ../modules/common/fingerprint-scanner.nix
      ];
    };
    impermanence = {
      system = [
        ../modules/disko/encrypted-btrfs-impermanence.nix
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
        ../modules/sops/default.nix
      ];
      home = [
        ../modules/sops/sops.nix
      ];
    };
    acme = {
      system = [
        ../modules/acme/default.nix
      ];
    };
    openssh-server = {
      system = [
        ../modules/common/openssh-server.nix
        ../modules/common/fail2ban.nix
      ];
    };
    # Profile to use on all desktops/laptops i.e. not servers
    workstation = {
      system = [
        ../apps/stylix/default.nix
        ../apps/udiskie/default.nix
        ../apps/symmetri/default.nix
        ../apps/workstation/default.nix
      ];
      home = [
        ../apps/bat/bat.nix
        ../apps/btop/btop.nix
        ../apps/editorconfig/editorconfig.nix
        ../apps/fish/fish.nix
        ../apps/git/git.nix
        ../apps/helix/helix.nix
        # ../apps/impulse/impulse.nix
        ../apps/lazygit/lazygit.nix
        ../apps/ledger/ledger.nix
        ../apps/mime/mime.nix
        ../apps/mpv/mpv.nix
        ../apps/nextcloud-client/nextcloud-client.nix
        # ../apps/nnn/nnn.nix
        ../apps/stylix/stylix.nix
        ../apps/swayimg/swayimg.nix
        ../apps/tealdeer/tealdeer.nix
        ../apps/tmux/tmux.nix
        ../apps/udiskie/udiskie.nix
        ../apps/workstation/workstation.nix
        ../apps/yazi/yazi.nix
        ../apps/zathura/zathura.nix
        ../apps/zoxide/zoxide.nix
      ];
    };
    niri = {
      system = [
        ../apps/niri/default.nix
      ];
      home = [
        ../apps/niri/niri.nix
        ../apps/noctalia/noctalia.nix
        ../apps/autoscreen/autoscreen.nix
        ../apps/ghostty/ghostty.nix
      ];
    };
    niri-waybar = {
      system = [
        ../apps/niri/default.nix
        ../apps/hyprlock/default.nix
      ];
      home = [
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
    nixflix = {
      system = [
        ../apps/nixflix/default.nix
      ];
    };
    bookorbit = {
      system = [
        ../apps/bookorbit/default.nix
      ];
    };
    shelfmark = {
      system = [
        ../apps/shelfmark/default.nix
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
    thunderbird = {
      home = [ ../apps/thunderbird/thunderbird.nix ];
    };
    chromium = {
      home = [ ../apps/ungoogled-chromium/ungoogled-chromium.nix ];
    };
    zen-browser = {
      home = [ ../apps/zen-browser/zen-browser.nix ];
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
        # ../apps/cursor/cursor.nix
        ../apps/opencode/opencode.nix
        ../apps/openskills/openskills.nix
        # ../apps/pi/pi.nix
        # ../apps/oh-my-pi/oh-my-pi.nix
        # ../apps/oh-my-opencode/oh-my-opencode.nix
        # ../apps/hermes/hermes.nix
        ../apps/rtk/rtk.nix
        ../apps/goose/goose.nix
        ../apps/ctx/ctx.nix
        ../apps/icm/icm.nix
      ];
    };
    hermes-server = {
      system = [
        ../apps/hermes-server/default.nix
      ];
      home = [
        ../apps/hermes-server/hermes-server.nix
        ../apps/hermes-server/mnemosyne.nix
      ];
    };
    opencode-server = {
      system = [
        ../apps/opencode-server/default.nix
      ];
      home = [
        ../apps/opencode/opencode.nix
      ];
    };
    zeroclaw = {
      system = [
        ../apps/zeroclaw/default.nix
      ];
    };
    adguard-home = {
      system = [
        ../apps/adguard-home/default.nix
      ];
    };
    qbittorrent = {
      system = [
        ../apps/qbittorrent/default.nix
      ];
    };
    tor-relay = {
      system = [
        ../apps/tor-relay/default.nix
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
    cairn = {
      system = [
        ../apps/cairn/default.nix
      ];
    };
    nextcloud-server = {
      system = [
        ../apps/nextcloud-server/default.nix
      ];
    };
    navidrome = {
      system = [ ../apps/navidrome/default.nix ];
    };
    audiomuse-ai = {
      system = [ ../apps/audiomuse-ai/default.nix ];
    };
    slskd = {
      system = [ ../apps/slskd/default.nix ];
    };
    maloja = {
      system = [ ../apps/maloja/default.nix ];
    };
    covertone = {
      system = [ ../apps/covertone/default.nix ];
    };
    immich = {
      system = [
        ../apps/immich/default.nix
      ];
    };
    jellyfin = {
      system = [
        ../apps/jellyfin/default.nix
      ];
    };
    paperless-ngx = {
      system = [
        ../apps/paperless-ngx/default.nix
      ];
    };
    trek = {
      system = [ ../apps/trek/default.nix ];
    };
  };
  mkHost =
    {
      hostName,
      stateVersion,
      system ? "x86_64-linux",
      domain ? defaultDomain,
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
          domain
          ;
      };
      modules = [
        ../modules/configuration.nix
        ../modules/overlays.nix
        ../modules/cachix/cachix.nix
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
                domain
                ;
              selectedProfiles = profiles;
            };
            users.${user} = {
              imports = [
                ../hosts/home-manager-common-config.nix
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
      "workstation"
      "niri"
      "android-tools"
      "steam"
      # "firefox"
      "zen-browser"
      "chromium"
      # "qutebrowser"
      # "mpd"
      "thunderbird"
      "python"
      "code-agents"
      # "mullvad"
      # "ollama"
      "restic"
      "sops"
    ];
    extraModules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen6
      {
        my.stylix.wallpaper = "nyc-425-park-avenue";
        disko.mainDisk = "/dev/nvme0n1";
      }
      # ../apps/boinc/default.nix
      ../modules/hardware/razer-naga.nix
    ];
  };

  cf-qv1 = mkHost {
    hostName = "cf-qv1";
    stateVersion = "26.05";
    profiles = [
      "laptop"
      "impermanence"
      "bootloader-systemd-boot"
      "workstation"
      "niri"
      "android-tools"
      "steam"
      # "firefox"
      "zen-browser"
      "chromium"
      "python"
      "code-agents"
      "sops"
      "restic"
      # "mullvad"
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
      # ../modules/hardware/throttled.nix
      # ../hosts/cf-qv1/throttled.nix
    ];
  };
  x1yoga = mkHost {
    hostName = "x1yoga";
    stateVersion = "25.05";
    profiles = [
      "laptop"
      "impermanence"
      "bootloader-systemd-boot"
      "workstation"
      "gnome"
      # "steam"
      # "firefox"
      "zen-browser"
      "chromium"
      # "python"
      "code-agents"
      # "sops"
    ];
    extraModules = [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      ../modules/common/screen-rotation.nix
      ../modules/hardware/throttled.nix
      ../modules/hardware/razer-naga.nix
      ../hosts/x1yoga/throttled.nix
      {
        my.stylix.wallpaper = "purple-waves";
      }
    ];
  };
  sg13 = mkHost {
    hostName = "sg13";
    stateVersion = "24.11";
    profiles = [
      "workstation"
      "bootloader-grub-uefi"
      "openssh-server"
      "gnome"
      "steam"
      # "firefox"
      "zen-browser"
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
      ../modules/hardware/razer-naga.nix
      {
        my.stylix.wallpaper = "nyc-425-park-avenue";
      }
      (_: {
        hardware.hid-tmff2.enable = true;
      })
    ];
  };
  nixos-kimsufi-qbittorrent = mkHost {
    hostName = "nixos-kimsufi-qbittorrent";
    stateVersion = "26.11";
    profiles = [
      "bootloader-grub-bios"
      "openssh-server"
      "qbittorrent"
    ];
  };
  nixos-kimsufi-tor = mkHost {
    hostName = "nixos-kimsufi-tor";
    stateVersion = "26.11";
    profiles = [
      "bootloader-grub-bios"
      "openssh-server"
      "sops"
      "tor-relay"
    ];
  };
  nixos-era-agents = mkHost {
    hostName = "nixos-era-agents";
    stateVersion = "26.11";
    domain = "agents.home.dbeley.ovh";
    profiles = [
      "bootloader-grub-bios"
      "openssh-server"
      "hermes-server"
      "opencode-server"
      "zeroclaw"
      "sops"
      "acme"
      # "cairn"
    ];
  };
  nixos-era-nixflix = mkHost {
    hostName = "nixos-era-nixflix";
    stateVersion = "26.05";
    domain = "nixflix.home.dbeley.ovh";
    profiles = [
      "bootloader-grub-bios"
      "openssh-server"
      "sops"
      "acme"
      "nixflix"
      "bookorbit"
      "shelfmark"
    ];
  };
  nixos-era-adguard = mkHost {
    hostName = "nixos-era-adguard";
    stateVersion = "26.05";
    profiles = [
      "bootloader-grub-bios"
      "openssh-server"
      "adguard-home"
      "sops"
      "acme"
    ];
  };
  nixos-era-nextcloud = mkHost {
    hostName = "nixos-era-nextcloud";
    stateVersion = "26.11";
    profiles = [
      "bootloader-grub-bios"
      "openssh-server"
      "nextcloud-server"
      "sops"
      "acme"
    ];
  };
  nixos-era-immich = mkHost {
    hostName = "nixos-era-immich";
    stateVersion = "26.11";
    profiles = [
      "bootloader-grub-bios"
      "openssh-server"
      "sops"
      "acme"
      "immich"
    ];
  };
  nixos-era-music = mkHost {
    hostName = "nixos-era-music";
    stateVersion = "26.11";
    domain = "music.home.dbeley.ovh";
    profiles = [
      "bootloader-grub-bios"
      "openssh-server"
      "navidrome"
      "audiomuse-ai"
      "sops"
      "acme"
      "slskd"
      "maloja"
      "covertone"
    ];
  };
  nixos-era-homelab = mkHost {
    hostName = "nixos-era-homelab";
    stateVersion = "26.11";
    domain = "homelab.home.dbeley.ovh";
    profiles = [
      "bootloader-grub-bios"
      "openssh-server"
      "sops"
      "acme"
      "jellyfin"
      "paperless-ngx"
      "trek"
    ];
  };
}
