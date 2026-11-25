# ZSW NixOS

Flake-based NixOS 26.05 in the default layout: `flake.nix`,
`configuration.nix`, `hardware-configuration.nix` and `home.nix` at the root,
with the user-facing config split into `config/*.nix`.

## Layout

| Path | Owns |
|---|---|
| `flake.nix` | Inputs (nixpkgs 26.05, home-manager 26.05, plasma-manager) and the `nixos` config |
| `configuration.nix` | system: nix settings, boot, kernel, locale, users, fonts, SDDM + Plasma + Hyprland sessions, PipeWire, NetworkManager/tailscale/avahi, services, system packages |
| `hardware-configuration.nix` | generated disk/CPU/VM config |
| `home.nix` | HM identity, user packages, nvim rsync activation, imports of `config/*.nix` |
| `config/kitty.nix` | kitty font/window/palette |
| `config/starship.nix` | prompt as `programs.starship.settings` |
| `config/shell.nix` | fish, atuin, zoxide, direnv, ssh-agent |
| `config/plasma.nix` | plasma theme, panel, wallpaper, Ctrl+Alt+T |
| `config/apps.nix` | fastfetch, btop, bottom, mpv configs |
| `config/hyprland.nix` | hypr, waybar, rofi, quickshell configs |
| `config/` | raw assets: nvim, Plasma theme, GTK theme, YAMIS icons, fish, hypr, waybar, rofi, quickshell |
| `MISSING.md` | what CachyOS has that this flake deliberately does not |

## Apply

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

The deployed copy in `/etc/nixos` is the source of truth on the machine; edit
the repo and copy it over (or point `--flake` at the repo).

```bash
sudo nix flake update --flake /etc/nixos
```

## Add a machine

Copy `hardware-configuration.nix` from the new machine, add a second
`nixosConfigurations.<name>` entry in `flake.nix` pointing at its own copy, and
branch the host-specific bits (`networking.hostName`, `boot.loader.*`,
`fileSystems`). Everything else is shared.

## Notes

- Plasma themes are applied by plasma-manager's autostart script on login, not
  at activation: `~/.local/share/plasma-manager/run_all.sh` applies colours,
  icons, cursor and the panel/wallpaper desktop scripts. Run it by hand to
  re-apply without logging out (needs `XAUTHORITY`, not just `DISPLAY`).
- The Monochrome global theme wants the Kvantum widget style; only its colour
  scheme, Plasma style, aurorae decoration and splash are used here.
- `config/starship.nix` holds the prompt as `programs.starship.settings`; the
  format strings contain Nerd Font private-use glyphs (U+E0B6/U+E0B4) that must
  stay byte-exact — an editor that strips them silently breaks the wedges.
- `config/nvim/` is rsynced rather than symlinked because LazyVim rewrites
  `lazy-lock.json` inside the config dir. Everything else under `config/` is
  linked read-only.
- Ctrl+Alt+T needs a logout/login: KWin registers global shortcuts at start.
- Fonts and the bash starship hook stay system-wide; everything user-facing is
  in home-manager.
