# What is not 1:1 with CachyOS

Everything below is either CachyOS-only, Arch-only, AUR-only with no nixpkgs
package, or tied to this specific hardware. Nothing here is a bug in the flake.

## Deliberately dropped: CachyOS / Arch tooling

| Package | Why | NixOS equivalent |
|---|---|---|
| `cachyos-*` (keyring, mirrorlists, settings, hooks, hello, kernel-manager, packageinstaller, rate-mirrors, update, wallpapers, KDE/GRUB/Plymouth themes) | Distro tooling | nixpkgs + `nixos-rebuild` |
| `linux-cachyos`, `linux-cachyos-lts` (+ headers) | Custom kernel | `boot.kernelPackages = linuxPackages_latest` (switch to `linux_zen`/xanmod if wanted) |
| `ananicy-cpp`, `scx_loader`, `bpftune-git`, `dmemcg-booster`, `amd-x3d-cache` | Scheduler/tuning daemons | none; not needed for correctness |
| `grub`, `grub-hook`, `grub-btrfs-support`, `grub-btrfs-snapper` | Arch package manager hooks | `boot.loader.grub` + NixOS generations; snapshots need `services.snapper` |
| `mkinitcpio`, `pacman-contrib`, `pkgfile`, `reflector`, `rebuild-detector`, `netctl` | Arch package management | none |
| `plymouth` CachyOS themes | Branding | stock Plymouth |

## AUR-only, no nixpkgs package

`apollo`, `char-white`, `exact-audio-copy`, `helium-browser-bin`, `hyprmod`,
`hyprpm`, `kwin-effects-better-blur-dx`, `millennium-git`, `nordvpn-gui-bin`,
`opendeck`, `optiscaler-client-bin`, `packettracer`, `plasma6-applets-kurve`,
`plasma6-wallpapers-smart-video-wallpaper-reborn`, `proton-cachyos-native`,
`rbonsai`, `samrewritten-git`, `shelly`, `shelly-flatpak-backend`,
`soulseekqt` (replaced by `nicotine-plus`), `vice-clipper`, `vortex-linux-fix`,
`xpadneo-dkms`.

Options: use the Flatpak where one exists, or add a small overlay later.

## Renamed / replaced, already handled

`bun-bin` → `bun`, `git-delta` → `delta`, `dua-cli` → `dua`, `go-yq` → `yq-go`,
`mesa-utils` → `mesa-demos`, `ntfs-3g` → `ntfs3g`, `nss-mdns` → `nssmdns`,
`polkit-gnome` → `polkit_gnome`, `topgrade-bin` → `topgrade`,
`usbmuxd-git` → `usbmuxd`, `device-mapper` → `lvm2`, `linuxconsole` → `kbd`,
`s-nail` → `mailutils`, `noto-fonts-emoji` → `noto-fonts-color-emoji`,
`taplo-cli` → `taplo`, `qt6ct` → `qt6Packages.qt6ct`,
`ttf-jetbrains-mono-nerd` → `nerd-fonts.jetbrains-mono`,
`ttf-meslo-nerd` → `nerd-fonts.meslo-lg`, `python-*` → `python3Packages.*`,
`gst-*` → `gst_all_1.*`, `lib32-mesa` → `pkgsi686Linux.mesa`,
`bibata-cursor-theme` → `bibata-cursors`, `plasma-firewall` →
`kdePackages.plasma-firewall`, `xwaylandvideobridge` (removed upstream in
Plasma 6).

## Hardware / host-specific, not enabled in the VM

| Item | Where it belongs |
|---|---|
| `virtualbox` + `virtualbox-host-dkms` | `virtualisation.virtualbox.host.enable` on c3po; nested virt is not usable here |
| `coolercontrol` daemon | no NixOS module; run the package as a systemd service on c3po |
| `nct6687d-dkms-git` | out-of-tree sensor module for the motherboard |
| `opencl-mesa` / `vulkan-radeon` / `lib32-*` | `mesa` covers the VM; c3po needs `hardware.graphics` with ROCm/Vulkan |
| btrfs subvolumes, GRUB-on-btrfs snapshots, Secure Boot | `hosts/c3po` with its own `hardware-configuration.nix` and `boot.loader` |
| `nordvpn` / `nordvpn-gui` | unfree, no nixpkgs package; `services.tailscale` is wired up instead |

## App config that is not declarative yet

`spicetify`, `GTK` asset overrides, `oh-my-posh`, and the Quickshell/waybar
themes are shipped as files but not driven by Nix options. `nvim` is rsynced
because LazyVim rewrites `lazy-lock.json`.
