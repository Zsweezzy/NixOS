{ pkgs, ... }:

{
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
}
