# System layer: boot, kernel, KDE, users, services.
# Everything user-facing (packages, kitty, starship, nvim, plasma shortcuts)
# lives in home.nix.
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Required to evaluate this flake.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ---------------------------------------------------------------- boot --
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.fsIdentifier = "provided";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ---------------------------------------------------------------- system --
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

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

  # ---------------------------------------------------------------- desktop --
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
  console.keyMap = "de";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  # ---------------------------------------------------------------- users --
  users.users.maxii = {
    isNormalUser = true;
    description = "maxii";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Nerd Font for the starship glyphs; system-wide so SDDM and KDE see it too.
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  programs.firefox.enable = true;

  # Shell integration stays system-wide: it is what writes the bash hook in
  # /etc/bashrc. The prompt itself is ~/.config/starship.toml from home.nix.
  programs.starship.enable = true;

  nixpkgs.config.allowUnfree = true;

  # ---------------------------------------------------------------- services --
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  virtualisation.virtualbox.guest.enable = true;

  system.stateVersion = "26.05";
}
