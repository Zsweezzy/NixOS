# fastfetch greeting; config lives in ~/.config/fastfetch.
function fish_greeting
    fastfetch
end

fish_add_path $HOME/.spicetify
fish_add_path $HOME/.local/share/pnpm/bin

# Starship prompt (config: ~/.config/starship.toml from home-manager).
if command -q starship
    starship init fish | source
end

# Aliases
alias e exit

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# GitHub MCP server auth for opencode's remote MCP entry. Derived from the
# authenticated gh CLI so the token is never hardcoded, and scoped to opencode
# instead of exported globally.
function opencode --description 'opencode with the GitHub MCP token'
    set -lx GITHUB_PERSONAL_ACCESS_TOKEN (gh auth token 2>/dev/null)
    command opencode $argv
end
