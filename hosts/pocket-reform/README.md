# MNT Pocket Reform i.MX8MP host

This host uses the hardware module from
[`dbeley/nixos-mnt-pocket-reform`](https://github.com/dbeley/nixos-mnt-pocket-reform).

## Boot layout

```
microSD p1 : /boot (ext4, label NIXOS_BOOT)
NVMe p1    : ext4 -> /
eMMC       : untouched Debian installation + U-Boot
```

The Pocket Reform U-Boot lives in the eMMC boot partition and only scans
`mmc0` (microSD), `mmc2` (eMMC) and USB. It does **not** scan the NVMe.
That is why `/boot` is on the microSD.


## First installation

Build the closure first (from the nixos-config checkout). The kernel comes
from the nixpkgs binary cache; only the MNT modules and the user closure are
built. Use a directory on the eMMC or another persistent disk, not the NVMe
that disko will wipe:

```bash
TMPDIR=/var/tmp nix build .#nixosConfigurations.pocket-reform.config.system.build.toplevel -L
```

Then run the installation script:

```bash
./scripts/install-pocket.sh
```

The script:

1. moves the Nix daemon build directory to `/var/lib/nix-build` (the NVMe is
   about to be wiped),
2. formats the microSD (`NIXOS_BOOT` 1 GiB + `NIXOS_DATA`),
3. runs disko on the NVMe (single ext4 root, no LUKS),
4. runs a pure `nixos-install` (no `--impure`),
5. sets the password for `david` (mutable users),
6. copies the current NetworkManager profiles into
   `/etc/NetworkManager/system-connections`.

It uses a `path:` flake reference so `disko` and `nixos-install` running as
root do not hit git's `safe.directory` checks.

## Rebuilding from NixOS

Clone the repository and use the `pocket-reform` branch:

```bash
git clone https://github.com/dbeley/nixos-config.git
cd nixos-config
git checkout pocket-reform
echo 'HOST=pocket-reform' > .env
just boot      # or: just switch
```

The hardware module installs `/boot/boot.scr` itself (safe U-Boot load
addresses) and removes the unusable `extlinux/` entry, so no manual step is
needed after `nixos-rebuild`.

## Checking the layout

```bash
findmnt /
lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINTS
```

Expected:

```
nvme0n1p1  ext4  (no label)  /
mmcblk0p1  ext4  NIXOS_BOOT /boot
```
