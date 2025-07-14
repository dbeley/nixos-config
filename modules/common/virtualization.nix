{
  lib,
  user,
  pkgs,
  ...
}:

{
  programs.dconf.enable = true;

  users.users.${user}.extraGroups = lib.mkMerge [[ "libvirtd" ]];

  environment.systemPackages = with pkgs; [
    virt-viewer
    virtio-win
    spice
    spice-gtk
    spice-protocol
    win-spice
  ];

  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };

  home-manager.users.${user} = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}
