{ pkgs, ... }:

{
  # System-wide packages: hardware, filesystems, boot, networking, printing,
  # audio plumbing and the CLI baseline. User-facing apps live in
  # modules/home/packages.nix.
  environment.systemPackages = with pkgs; [
    # ------------------------------------------------------- firmware / hw --
    linux-firmware
    sof-firmware
    alsa-firmware
    xf86-video-amdgpu
    dmidecode
    lshw
    hwinfo
    lsscsi
    hdparm
    smartmontools
    sysfsutils
    sg3_utils
    pv
    mtools
    fsarchiver

    # --------------------------------------------------------- filesystems --
    btrfs-progs
    btrfs-assistant
    snapper
    dosfstools
    e2fsprogs
    exfatprogs
    f2fs-tools
    jfsutils
    nilfs-utils
    xfsprogs
    ntfs3g
    ntfsprogs
    mdadm
    lvm2
    cryptsetup
    dmraid

    # ---------------------------------------------------------------- boot --
    efibootmgr
    efitools
    sbctl
    os-prober
    plymouth

    # ------------------------------------------------------------- network --
    networkmanager
    networkmanager-openvpn
    modemmanager
    wpa_supplicant
    tailscale
    cloudflared
    dnsmasq
    xl2tpd
    bind
    inetutils
    ethtool
    usbutils
    usbmuxd
    bluez
    bluez-tools

    # ------------------------------------------------------------ printing --
    cups
    cups-filters
    cups-pdf-to-pdf
    foomatic-db
    foomatic-db-engine
    foomatic-db-nonfree
    foomatic-db-ppds
    gutenprint
    hplip
    ghostscript
    system-config-printer

    # --------------------------------------------------------------- audio --
    alsa-utils
    alsa-plugins
    pavucontrol
    pamixer
    playerctl
    wireplumber

    # ------------------------------------------------------ desktop plumbing --
    accountsservice
    upower
    fwupd
    flatpak
    xdg-user-dirs
    kdePackages.plasma-firewall
    power-profiles-daemon

    # ------------------------------------------------------- CLI baseline --
    bash-completion
    man-db
    man-pages
    texinfo
    less
    nano
    vim
    which
    wget
    unzip
    zip
    unrar
    rsync
    tree
    tmux
    strace
    ncdu
    plocate
    logrotate
    sudo
    age
    sops

    # ---------------------------------------------------------- dev base --
    git
    cmake
    go
    python3
    perl
    patchelf
    just
    shellcheck
    shfmt
    prettier
    biome
    stylua
    taplo
    rust-analyzer
    rustup

    # -------------------------------------------------------------- gaming --
    gamescope
    mangohud
    lutris
    protonplus
    gpu-screen-recorder
  ];
}
