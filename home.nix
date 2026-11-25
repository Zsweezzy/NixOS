{ pkgs, lib, ... }:

{
  # ---------------------------------------------------------------- identity --
  home.username = "maxii";
  home.homeDirectory = "/home/maxii";
  home.stateVersion = "26.05";

  # ------------------------------------------------------------- packages --
  home.packages = with pkgs; [
    neovim
    kdePackages.kate

    # Neovim + what LazyVim plugins shell out to.
    # git: lazy.nvim/mason | gcc+gnumake: treesitter | ripgrep/fd: telescope
    # unzip: mason | nodejs: LSP servers | tree-sitter: CLI
    git
    ripgrep
    fd
    gcc
    gnumake
    unzip
    nodejs
    tree-sitter
  ];

  # ----------------------------------------------------------------- config --
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    settings = {
      remember_window_size = false;
      initial_window_width = 1300;
      initial_window_height = 700;

      # Tokyo Night Moon
      background = "#222436";
      foreground = "#c8d3f5";
      selection_background = "#2d3f76";
      selection_foreground = "#c8d3f5";
      cursor = "#c8d3f5";
      cursor_text_color = "#222436";
      color0 = "#1b1d2b";
      color1 = "#ff757f";
      color2 = "#c3e88d";
      color3 = "#ffc777";
      color4 = "#82aaff";
      color5 = "#c099ff";
      color6 = "#86e1fc";
      color7 = "#828bb8";
      color8 = "#444a73";
      color9 = "#ff8d94";
      color10 = "#c7fb6d";
      color11 = "#ffd8ab";
      color12 = "#9ab8ff";
      color13 = "#caabff";
      color14 = "#b2ebff";
      color15 = "#c8d3f5";
    };
  };

  # The TOML ships verbatim: programs.starship.settings re-serializes it and
  # mangles the format strings (verified on C3PO).
  home.file.".config/starship.toml".source = ./files/starship.toml;

  # LazyVim rewrites lazy-lock.json inside the config dir, so it cannot be a
  # read-only store symlink; copy the tree in on every activation instead.
  home.activation.nvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "$HOME/.config/nvim"
    run ${pkgs.rsync}/bin/rsync -a --delete ${./files/nvim}/ "$HOME/.config/nvim/"
  '';

  # ---------------------------------------------------------------- plasma --
  # Ctrl+Alt+T -> kitty. KGlobalAccel only picks up .desktop files that opt in
  # as command shortcuts, hence the flag; the section is [services][<file>].
  # (home.file, not xdg.desktopEntries: that option throws "extraConfig removed"
  # on home-manager 26.05.)
  home.file.".local/share/applications/kitty-terminal.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Kitty Terminal
    Exec=${pkgs.kitty}/bin/kitty
    NoDisplay=true
    StartupNotify=false
    X-KDE-GlobalAccel-CommandShortcut=true
  '';

  programs.plasma = {
    enable = true;
    shortcuts = {
      "services/kitty-terminal.desktop"._launch = "Ctrl+Alt+T";
      "services/org.kde.konsole.desktop"._launch = [ ];
    };
  };
}
