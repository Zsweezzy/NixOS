{ pkgs, ... }:

{
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
  boot.loader.grub.useOSProber = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  zramSwap.enable = true;

  # ------------------------------------------------------------- system --
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
}
