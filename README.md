# ZSW NixOS

Flake-based NixOS 26.05 config: system layer + home-manager + plasma-manager.

## Layout

| Path | Owns |
|---|---|
| `flake.nix` | Inputs (nixpkgs 26.05, home-manager 26.05, plasma-manager) and the `nixos` host |
| `configuration.nix` | boot, kernel, KDE Plasma, users, pipewire, sshd, fonts, shell starship hook |
| `hardware-configuration.nix` | this machine's disks (VM) |
| `home.nix` | user packages, kitty, starship TOML, neovim, Ctrl+Alt+T shortcut |
| `files/kitty.conf` | kitty config, theme inlined |
| `files/starship.toml` | starship config, shipped verbatim |
| `files/nvim/` | LazyVim config, copied into `~/.config/nvim` on activation |

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

- `files/starship.toml` is a file, not `programs.starship.settings`: the settings
  path re-serializes the TOML and mangles the `format` strings.
- `files/nvim/` is rsynced rather than symlinked because LazyVim rewrites
  `lazy-lock.json` inside the config dir.
- Ctrl+Alt+T needs a logout/login: KWin registers global shortcuts at start.
- Fonts and the starship bash hook stay system-wide; everything user-facing is
  in home-manager.

## Another machine

Add `hosts/<name>/hardware-configuration.nix` plus a `nixosConfigurations.<name>`
entry in `flake.nix`, and point its `home.nix` at the same `files/`.
