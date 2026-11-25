# ZSW NixOS

Flake-based NixOS 26.05: one directory per host, shared system modules,
home-manager for everything user-facing, plasma-manager for KDE.

## Layout

| Path | Owns |
|---|---|
| `flake.nix` | Inputs (nixpkgs 26.05, home-manager 26.05, plasma-manager) and `mkHost` |
| `hosts/vm/` | this VM: hostname, boot device, generated `hardware-configuration.nix` |
| `modules/nixos/base.nix` | nix settings, boot, kernel, locale, users, fonts, zram |
| `modules/nixos/desktop.nix` | SDDM, Plasma 6, Hyprland session, portals, keyboard |
| `modules/nixos/audio.nix` | PipeWire + the x11-bell logout fix |
| `modules/nixos/network.nix` | NetworkManager, firewall, tailscale, avahi, resolved |
| `modules/nixos/services.nix` | sshd, bluetooth, printing, fwupd, keyd, steam, OpenRGB |
| `modules/nixos/packages.nix` | system-wide packages (hardware, fs, boot, printing, CLI) |
| `modules/home/` | HM modules: packages, shell, terminal, editor, desktop, apps, hyprland |
| `users/maxii.nix` | HM entry point for the user |
| `config/` | raw assets: nvim, Plasma theme, fish, fastfetch, btop, mpv, hypr, quickshell |
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

Create `hosts/<name>/default.nix` (hostname, boot loader, hardware config) and
add one line to `nixosConfigurations` in `flake.nix`:

```nix
c3po = mkHost "c3po";
```

`modules/` and `users/` are shared, so the desktop, shell and packages come
along automatically.

## Notes

- Plasma themes are applied by plasma-manager's autostart script on login, not
  at activation: `~/.local/share/plasma-manager/run_all.sh` applies colours,
  icons, cursor and the panel/wallpaper desktop scripts. Run it by hand to
  re-apply without logging out (needs `XAUTHORITY`, not just `DISPLAY`).
- The Monochrome global theme wants the Kvantum widget style; only its colour
  scheme, Plasma style, aurorae decoration and splash are used here.
- `modules/home/shell.nix` holds the prompt as `programs.starship.settings`; the
  format strings contain Nerd Font private-use glyphs (U+E0B6/U+E0B4) that must
  stay byte-exact — an editor that strips them silently breaks the wedges.
- `config/nvim/` is rsynced rather than symlinked because LazyVim rewrites
  `lazy-lock.json` inside the config dir. Everything else under `config/` is
  linked read-only.
- Ctrl+Alt+T needs a logout/login: KWin registers global shortcuts at start.
- Fonts and the bash starship hook stay system-wide; everything user-facing is
  in home-manager.
