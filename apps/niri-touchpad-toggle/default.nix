{
  inputs,
  user,
  ...
}:
{
  imports = [ inputs.niri-touchpad-toggle.nixosModules.default ];

  # Runtime touchpad toggle for niri (niri PR #3316 is still unmerged and niri
  # has no plugin API). The daemon grabs the touchpad evdev node when disabled;
  # the CLI flips it over a UNIX socket. Bound to Mod+Ctrl+T in apps/niri/niri.nix.
  programs.niri-touchpad-toggle = {
    enable = true;
    inherit user;
  };
}
