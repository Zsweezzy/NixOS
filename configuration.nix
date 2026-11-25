# System layer: boot, kernel, KDE, services, system packages.
# Everything user-facing (user packages, kitty, starship, fish, plasma, hypr)
# lives in home.nix and config/*.nix.
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # ---------------------------------------------------------------- nix --
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nixpkgs.config.allowUnfree = true;

  # --------------------------------------------------------------- boot --
  boot.loader.grub.enable = true;
  # BIOS/GRUB on this VM; the real machine is EFI and sets its own loader.
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.fsIdentifier = "provided";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  zramSwap.enable = true;

  # ------------------------------------------------------------- system --
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
  console.keyMap = "de";

  system.stateVersion = "26.05";

  # -------------------------------------------------------------- users --
  users.users.maxii = {
    isNormalUser = true;
    description = "maxii";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "input"
      "lp"
      "storage"
      "video"
      "rfkill"
      "vboxusers"
    ];
  };

  # -------------------------------------------------------------- fonts --
  # Nerd Fonts for the shell/editor glyphs, Noto/DejaVu/Liberation for the rest.
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    cantarell-fonts
    dejavu_fonts
    liberation_ttf
    open-sans
  ];

  # ------------------------------------------------------------ desktop --
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  services.libinput.enable = true;

  # Both sessions are offered: Plasma (default) and Hyprland.
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-hyprland
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
  };

  # -------------------------------------------------------------- audio --
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # module-x11-bell segfaults in its X11 IO-error handler when the session's X
  # connection dies at logout (loop_destroy_source from inside the callback),
  # which then makes drkonqi abort in a loop. It only plays the terminal bell,
  # and without DISPLAY it is skipped, so strip the display from the service.
  systemd.user.services.pipewire.serviceConfig.UnsetEnvironment = [ "DISPLAY" "XAUTHORITY" ];

  # ------------------------------------------------------------ network --
  services.resolved.enable = true;
  services.tailscale.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # ----------------------------------------------------------- services --
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.printing.enable = true;
  services.gvfs.enable = true;

  services.fwupd.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  services.flatpak.enable = true;

  # Host has keyd and OpenRGB udev rules.
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "320f:505a" ];
      settings.main = {
        capslock = "f19";
        f13 = "f19";
      };
    };
  };
  services.udev.packages = [ pkgs.openrgb ];

  programs.steam.enable = true;
  programs.gamemode.enable = true;

  # ------------------------------------------------- system packages --
  # Hardware, filesystems, boot, networking, printing, audio plumbing and the
  # CLI baseline. User-facing apps live in home.nix.
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
