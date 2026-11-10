# home.nix — Home Manager configuration for user "maxii"
#
# Rebuilt from ~/Backups/nix-2026-10-17/home.nix (the prior working config),
# adapted to the channel-based install: stateVersion bumped 24.05 → 25.11.
#
# Apply with:   home-manager switch
# Update with:   nix-channel --update && home-manager switch

{ config, pkgs, ... }:

{
  # ---------------------------------------------------------------- identity --
  home.username = "maxii";
  home.homeDirectory = "/home/maxii";

  # HM 25.11 requires this; it also pins the module-system version used for
  # option migrations. Bumped from 24.05 to match the installed release.
  home.stateVersion = "25.11";

  # In standalone mode the backup flag is a CLI option, not a config option:
#   home-manager switch -b backup
# It moves any file a module would clobber to <name>.backup before writing.

  # ------------------------------------------------------------- packages --
  # Packages installed into the user profile (nix-env default path).
  # GUI/GL apps intentionally NOT here: Nix-built GL binaries cannot
  # initialize EGL against the system Mesa/AMD drivers on non-NixOS (verified:
  # `kitty` from the nix store errors with "EGL: Failed to initialize EGL"). It stays on pacman,
  # where it uses the system driver stack. See the home.packages comment
  # above for the same reason GUI/GL apps are excluded.
  home.packages = with pkgs; [
    # --- core utils ---
    lsd
    bat
    eza
    fd
    fzf
    ripgrep
    jq
    yq-go
    zoxide
    # --- shell ---
    atuin
    direnv
    zsh
    fish
    nushell
    bash-completion
    # --- editors ---
    neovim
    helix
    micro
    # --- dev tooling ---
    git
    gh
    lazygit
    gitui
    nodejs
    bun
    python3
    uv
    pipx
    rustup
    go
    clang
    cmake
    pkg-config
    ninja
    meson
    just
    gnumake
    shellcheck
    shfmt
    # --- formatters ---
    nixfmt
    alejandra
    taplo
    stylua
    biome
    prettier
    sd
    # --- misc ---
    bottom
    btop
    dust
    procs
    htop
    fastfetch
    hyfetch
    tree
    wget
    curl
    unzip
    p7zip
    zip
    tmux
    zellij
    tokei
    hyperfine
    tealdeer
    glow
    cht-sh
    doggo
    xh
    httpie
    delta
    difftastic
    rsync
    openssl
    age
    sops
    gnupg
    pinentry-curses
    pciutils
    usbutils
    lsof
    killall
    ncdu
    dua
    yt-dlp
    ffmpeg-full
    ffmpegthumbnailer
    imagemagick
    yazi
    duf
    cbonsai
    cmatrix
    glances
    hwinfo
    strace
    pv
    less
    nano
    playerctl
    brightnessctl
    wl-clipboard
    cliphist
    grim
    slurp
    poppler-utils
    tesseract
    lshw
    dmidecode
    file
    which
    wdiff
    colordiff
    icdiff
  ];

  # ------------------------------------------------- home.file / programs --
  # programs.*.enable = true modules write their own config files.
  # home.file.<path>.source copies a file into $HOME verbatim.

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.atuin.enable = true;
  programs.zoxide.enable = true;
  programs.fzf.enable = true;
  programs.bat.enable = true;
  programs.eza.enable = true;

  # Starship TOML config - written directly to preserve TOML syntax
  # (programs.starship.settings JSON-to-TOML conversion double-escapes format strings)
  home.file.".config/starship.toml".text = ''
    # Generated: Tokyo Night theme - catppuccin-style transition wedges
    # Segments: session / path / git / node / time (left), aws (right)
    # Minor differences vs OMP:
    #  - git stash count / ahead-behind symbols sit outside the branch parens
    #  - at $HOME the directory shows "~" instead of the home folder name
    #  - node shows the  (engine) icon instead of the package-manager icon

    format = """
    [](#82aaff)\
    $username\
    [](#82aaff bg:#bb9af7)\
    $directory\
    [](#bb9af7 bg:#9ece6a)\
    $git_branch\
    $git_status\
    [](#9ece6a bg:#9ece6a)\
    $nodejs\
    [](#9ece6a bg:#f7768e)\
    $time\
    [ ](#f7768e)\
    """

    right_format = '$aws'

    [aws]
    format = '[❯](#1a1b26)[ $symbol$profile(@$region) ]($style)[❯](#1a1b26)'
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

  # Enable starship for fish shells
  programs.starship.enable = true;
  programs.starship.enableFishIntegration = true;

  # Kitty is NOT here. Nixpkgs' kitty fails EGL initialization against the
  # system Mesa/AMD drivers on non-NixOS (verified: `kitty` from the nix
  # store errors with "EGL: Failed to initialize EGL"). It stays on pacman,
  # where it uses the system driver stack. See the home.packages comment
  # above for the same reason GUI/GL apps are excluded.
}