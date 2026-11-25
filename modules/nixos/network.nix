{ ... }:

{
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  services.resolved.enable = true;

  services.tailscale.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
