{ ... }:

{
  # Hyprland reads the Lua config directly and Quickshell/waybar/rofi only read
  # their files, so they can be plain store symlinks.
  xdg.configFile = {
    "hypr/hyprland.lua".source = ./hypr/hyprland.lua;
    "hypr/hyprland.conf".source = ./hypr/hyprland.conf;
    "hypr/hyprlock.conf".source = ./hypr/hyprlock.conf;
    "hypr/scripts".source = ./hypr/scripts;

    "waybar".source = ./waybar;
    "rofi".source = ./rofi;
    "quickshell".source = ./quickshell;
  };
}
