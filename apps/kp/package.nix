{ pkgs, database }:
pkgs.writeShellApplication {
  name = "kp";
  runtimeInputs = with pkgs; [
    coreutils
    keepassxc
    libnotify
    tofi
    wl-clipboard-rs
  ];
  text =
    builtins.replaceStrings [ "@database@" "@awk@" ] [ database (toString ./ls-r-to-paths.awk) ]
      (builtins.readFile ./kp.sh);
}
