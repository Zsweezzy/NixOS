{ ... }:

{
  # Hyprland reads the Lua config directly and Quickshell/waybar/rofi only read
  # their files, so they can be plain store symlinks.
  xdg.configFile = {
    "hypr/hyprland.lua".source = ../../config/hypr/hyprland.lua;
    "hypr/hyprland.conf".source = ../../config/hypr/hyprland.conf;
    "hypr/hyprlock.conf".source = ../../config/hypr/hyprlock.conf;
    "hypr/scripts".source = ../../config/hypr/scripts;

    "waybar".source = ../../config/waybar;
    "rofi".source = ../../config/rofi;
    "quickshell".source = ../../config/quickshell;
  };
}
