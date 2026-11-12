# NixOS — Starship Configuration

Home Manager configuration with embedded starship.toml.

## Quick Start

```bash
# Clone to ~/.config/nixpkgs/ or ~/projects/ZSW-NixOS/
git clone https://github.com/Zsweezzy/NixOS.git ~/.config/nixpkgs/

# Apply the configuration
home-manager switch
```

## What's Included

- **Starship prompt** with Tokyo Night/catppuccin theme
- **Fish shell integration** enabled automatically
- **No external TOML files** - configuration is embedded in Nix

## The Theme

Catppuccin-style transition wedges with segments:
- Username & computer name
- Directory path
- Git branch & status
- Node.js version
- Time display

## Requirements

- Home Manager 25.11+
- Starship 1.24.2+
- Fish shell (or enableFishIntegration in the config)