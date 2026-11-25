{ ... }:

{
  # fastfetch / btop / bottom / mpv: static configs, linked read-only.
  xdg.configFile = {
    "fastfetch".source = ./fastfetch;
    "btop".source = ./btop;
    "bottom".source = ./bottom;
    "mpv".source = ./mpv;
  };
}
