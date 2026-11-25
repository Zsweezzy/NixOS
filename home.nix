{ pkgs, lib, ... }:

{
  imports = [
    ./config/kitty.nix
    ./config/plasma.nix
    ./config/shell.nix
    ./config/starship.nix
    ./config/apps.nix
    ./config/hyprland.nix
  ];

  # ---------------------------------------------------------------- identity --
  home.username = "maxii";
  home.homeDirectory = "/home/maxii";
  home.stateVersion = "26.05";

  # ------------------------------------------------------------- packages --
  home.packages = with pkgs; [
    # ------------------------------------------------- terminals / editors --
    neovim
    kdePackages.kate
    vim
    meld

    # ------------------------------------------------------------ browsers --
    firefox
    google-chrome

    # ------------------------------------------------------- KDE / Plasma --
    kdePackages.ark
    kdePackages.dolphin
    kdePackages.konsole
    kdePackages.kdialog
    kdePackages.kscreen
    kdePackages.kwalletmanager
    kdePackages.kwallet-pam
    kdePackages.kdeplasma-addons
    kdePackages.kde-gtk-config
    kdePackages.breeze-gtk
    kdePackages.bluedevil
    kdePackages.plasma-nm
    kdePackages.plasma-pa
    kdePackages.plasma-thunderbolt
    kdePackages.powerdevil
    kdePackages.plasma-browser-integration
    kdePackages.phonon-vlc
    kdePackages.qtmultimedia
    kdePackages.qtstyleplugin-kvantum

    # ----------------------------------------------------------- theming --
    qt6Packages.qt6ct
    nwg-look
    bibata-cursors
    papirus-icon-theme

    # ------------------------------------------------------------- media --
    mpv
    spotify
    vlc
    ffmpegthumbnailer
    libdvdcss
    libheif
    libgsf
    libopenraw
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-base

    # --------------------------------------------------------------- CLI --
    atuin
    bottom
    btop
    cbonsai
    cmatrix
    colordiff
    difftastic
    delta
    duf
    dust
    dua
    eza
    fastfetch
    gitui
    glances
    glow
    yq-go
    httpie
    xh
    hyfetch
    hyperfine
    icdiff
    lazygit
    lsd
    nushell
    procs
    superfile
    yazi
    tokei
    wdiff
    zoxide
    yt-dlp

    # --------------------------------------------------------------- dev --
    github-cli
    opencode
    direnv
    bun
    nodejs

    # ---------------------------------------------------------- Hyprland --
    hyprland
    hyprlauncher
    hyprlock
    hyprpaper
    hyprpicker
    hyprpolkitagent
    hyprshot
    hyprsunset
    waybar
    rofi
    mako
    swaybg
    swaylock
    quickshell
    uwsm
    xwayland-satellite
    grim
    slurp
    satty
    cliphist
    brightnessctl
    wmctrl
    xdotool
    xclip
    ydotool
    xsettingsd
    gtk4-layer-shell

    # -------------------------------------------------------------- apps --
    qalculate-qt
    tesseract
    seahorse
    pika-backup
    xdg-ninja
    nicotine-plus
    openrgb
    openrgb-plugin-effects

    # ------------------------------------------------------- python libs --
    # Used by the user's own scripts.
    python3Packages.aiohttp
    python3Packages.build
    python3Packages.defusedxml
    python3Packages.eyed3
    python3Packages.installer
    python3Packages.packaging
    python3Packages.pipx
    python3Packages.pyqt5
    python3Packages.pyqt6-webengine
    python3Packages.pywebview
    python3Packages.qtpy
    python3Packages.reportlab
    python3Packages.setuptools
    python3Packages.stem
    python3Packages.systemd-python
    python3Packages.tomli-w
    python3Packages.websockets

    # ------------------------------------------------------------ Neovim --
    # What LazyVim plugins shell out to.
    # git: lazy.nvim/mason | gcc+gnumake: treesitter | ripgrep/fd: telescope
    # unzip: mason | nodejs: LSP servers | tree-sitter: CLI
    git
    ripgrep
    fd
    gcc
    gnumake
    unzip
    tree-sitter
  ];

  # ----------------------------------------------------------------- config --
  # LazyVim rewrites lazy-lock.json inside the config dir, so it cannot be a
  # read-only store symlink; copy the tree in on every activation instead.
  home.activation.nvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "$HOME/.config/nvim"
    run ${pkgs.rsync}/bin/rsync -a --delete ${./config/nvim}/ "$HOME/.config/nvim/"
  '';
}
