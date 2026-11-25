{ ... }:

{
  # fastfetch / btop / bottom / mpv: static configs, linked read-only.
  xdg.configFile = {
    "fastfetch".source = ../../config/fastfetch;
    "btop".source = ../../config/btop;
    "bottom".source = ../../config/bottom;
    "mpv".source = ../../config/mpv;
  };
}
