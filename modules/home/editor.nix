{ pkgs, lib, ... }:

{
  # Neovim + what LazyVim plugins shell out to.
  # git: lazy.nvim/mason | gcc+gnumake: treesitter | ripgrep/fd: telescope
  # unzip: mason | nodejs: LSP servers | tree-sitter: CLI
  home.packages = with pkgs; [
    neovim
    git
    ripgrep
    fd
    gcc
    gnumake
    unzip
    nodejs
    tree-sitter
  ];

  # LazyVim rewrites lazy-lock.json inside the config dir, so it cannot be a
  # read-only store symlink; copy the tree in on every activation instead.
  home.activation.nvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "$HOME/.config/nvim"
    run ${pkgs.rsync}/bin/rsync -a --delete ${../../config/nvim}/ "$HOME/.config/nvim/"
  '';
}
