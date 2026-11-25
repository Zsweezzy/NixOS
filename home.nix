{ pkgs, lib, ... }:

{
  imports = [
    ./config/kitty.nix
    ./config/starship.nix
  ];

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
  # LazyVim rewrites lazy-lock.json inside the config dir, so it cannot be a
  # read-only store symlink; copy the tree in on every activation instead.
  home.activation.nvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "$HOME/.config/nvim"
    run ${pkgs.rsync}/bin/rsync -a --delete ${./config/nvim}/ "$HOME/.config/nvim/"
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
