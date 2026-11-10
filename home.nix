# home.nix — Home Manager configuration with embedded starship config
#
# Usage:
#   home-manager switch
#
# For a fresh NixOS install:
#   1. Clone this repo to /etc/nixos/ (or ~/.config/nixpkgs/)
#   2. Run: home-manager switch
#
# This writes starship.toml directly via home.file to preserve TOML syntax

{ config, pkgs, ... }:

{
  ##################################################################
  # Identity
  ##################################################################
  home.username = "maxii";
  home.homeDirectory = "/home/maxii";
  home.stateVersion = "25.11";

  ##################################################################
  # Packages
  ##################################################################
  home.packages = with pkgs; [
    fish
  ];

  ##################################################################
  # Programs
  ##################################################################
  programs.home-manager.enable = true;
  programs.starship.enable = true;
  programs.starship.enableFishIntegration = true;

  # Starship TOML config - written directly to preserve TOML syntax
  home.file.".config/starship.toml".text = ''
    # Generated: Tokyo Night theme - catppuccin-style transition wedges
    # Segments: session / path / git / node / time (left), aws (right)
    # Minor differences vs OMP:
    #  - git stash count / ahead-behind symbols sit outside the branch parens
    #  - at $HOME the directory shows "~" instead of the home folder name
    #  - node shows the  (engine) icon instead of the package-manager icon

    format = """
    [❮](#1a1b26)\
    $username\
    [❯](#bb9af7 bg:#1a1b26)\
    $directory\
    [❯](#9ece6a bg:#bb9af7)\
    $git_branch\
    $git_status\
    [❯](#9ece6a bg:#9ece6a)\
    $nodejs\
    [❯](#f7768e bg:#9ece6a)\
    $time\
    [❯ ](#f7768e)\
    """

    right_format = "$aws"

    [aws]
    format = "[❯](#1a1b26)[ $symbol$profile(@$region) ]($style)[❯](#1a1b26)"
    symbol = ""
    style = "bg:#1a1b26 fg:#82aaff"

    [username]
    show_always = true
    format = "[$user ]($style)"
    style_user = "bg:#82aaff fg:#1a1b26"
    style_root = "bg:#82aaff fg:#1a1b26"

    [directory]
    format = "[ $path ]($style)"
    style = "bg:#bb9af7 fg:#1a1b26"
    truncation_length = 1
    truncation_symbol = ""
    truncate_to_repo = false

    [git_branch]
    symbol = ""
    format = "[  ($branch) ]($style)"
    style = "bg:#bb9af7 fg:#1a1b26"

    [git_status]
    style = "bg:#bb9af7 fg:#1a1b26"
    format = "[( $stashed$ahead_behind)]($style)"
    stashed = "$count"
    ahead = "↑"
    behind = "↓"
    diverged = "⇕"
    up_to_date = ""
    conflicted = ""
    untracked = ""
    modified = ""
    staged = ""
    renamed = ""
    deleted = ""
    ignore_submodules = false

    [nodejs]
    symbol = ""
    format = "[ $symbol 7.2.10-1-cachyos ]($style)"
    style = "bg:#9ece6a fg:#1a1b26"

    [time]
    disabled = false
    format = "[ ♥ $time ]($style)"
    time_format = "%R"
    style = "bg:#f7768e fg:#1a1b26"
  '';
}