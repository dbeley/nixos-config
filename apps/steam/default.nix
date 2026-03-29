{ pkgs, ... }:
{
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  # Gaming-oriented kernel tuning
  boot.kernel.sysctl = {
    # Keep more in RAM, reduce swap tendency (default 60 is too aggressive with 24GB+)
    "vm.swappiness" = 10;
    # Disable proactive memory compaction (eliminates latency spikes during gameplay)
    "vm.compaction_proactiveness" = 0;
    # Disable split lock mitigation (prevents micro-stutters in some games/emulators)
    "kernel.split_lock_mitigate" = 0;
  };
}
