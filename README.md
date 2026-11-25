# ZSW NixOS

Flake-based NixOS 26.05 config: system layer + home-manager + plasma-manager.

## Layout

| Path | Owns |
|---|---|
| `flake.nix` | Inputs (nixpkgs 26.05, home-manager 26.05, plasma-manager) and the `nixos` host |
| `configuration.nix` | boot, kernel, KDE Plasma, users, pipewire, sshd, fonts, shell starship hook |
| `hardware-configuration.nix` | this machine's disks (VM) |
| `home.nix` | user packages, neovim, Ctrl+Alt+T shortcut, module imports |
| `config/kitty.nix` | kitty: font, window size, Tokyo Night Moon palette |
| `config/starship.nix` | starship prompt: Tokyo Night Moon segments |
| `config/nvim/` | LazyVim config, copied into `~/.config/nvim` on activation |

## Apply

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

`/etc/nixos` holds a copy of this repo. Keep this repo as the source of truth and
re-copy after edits.

## Update

```bash
sudo nix flake update --flake /etc/nixos
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

## Notes

- `config/starship.nix` holds the prompt as `programs.starship.settings`; the
  format strings contain Nerd Font private-use glyphs (U+E0B6/U+E0B4) that must
  stay byte-exact — an editor that strips them silently breaks the wedges.
- `config/nvim/` is rsynced rather than symlinked because LazyVim rewrites
  `lazy-lock.json` inside the config dir.
- Ctrl+Alt+T needs a logout/login: KWin registers global shortcuts at start.
- Fonts and the starship bash hook stay system-wide; everything user-facing is
  in home-manager.

## Another machine

Add `hosts/<name>/hardware-configuration.nix` plus a `nixosConfigurations.<name>`
entry in `flake.nix`, and point its `home.nix` at the same `config/`.
