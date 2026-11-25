{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  networking.hostName = "nixos";

  # Boot is BIOS/GRUB on this VM; the real machine is EFI and will set its own
  # loader in hosts/c3po.
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.fsIdentifier = "provided";

  system.stateVersion = "26.05";
}
