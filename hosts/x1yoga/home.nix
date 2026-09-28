{
  pkgs,
  lib,
  user,
  ...
}:
{
  home.packages = with pkgs; [
    # audacity
    beets
    # discord
    # heroic
    # jamulus
    # musescore
    nautilus
    papers
    # shotcut
    # transcribe
    wvkbd
  ];

  programs.chromium.commandLineArgs = [
    "--enable-low-end-device-mode"
    "--renderer-process-limit=4"
    "--process-per-site"
    "--js-flags=--max-old-space-size=768"
  ];

  programs.zen-browser.profiles.${user}.settings = {
    "dom.ipc.processCount" = 4;
    "dom.ipc.processCount.webIsolated" = 2;
    "browser.cache.memory.capacity" = 65536;
    "browser.tabs.unloadOnLowMemory" = true;
    "media.memory_cache_max_size" = 8192;
  };

  dconf.settings = {
    "org/gnome/desktop/a11y/applications" = {
      screen-keyboard-enabled = lib.mkForce true;
    };
    "org/gnome/desktop/interface" = {
      toolkit-accessibility = lib.mkForce true;
    };
  };
}
