{ lib, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = lib.fileContents ../../config/fish/config.fish;
  };
  xdg.configFile."fish/conf.d/ssh-agent.fish".source = ../../config/fish/conf.d/ssh-agent.fish;
  xdg.configFile."fish/completions".source = ../../config/fish/completions;

  programs.atuin.enable = true;
  programs.zoxide.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  services.ssh-agent.enable = true;

  # config.fish already runs `starship init fish`.
  programs.starship.enableFishIntegration = false;

  # Serialized by home-manager into ~/.config/starship.toml.
  # Tokyo Night Moon: each segment is a solid block and the  wedges carry the
  # neighbouring background, so the slant reads as a transition.
  programs.starship = {
    enable = true;

    settings = {
      format = "[](#82aaff)$username[](#82aaff bg:#bb9af7)$directory[](#bb9af7 bg:#9ece6a)$git_branch$git_status[](#9ece6a bg:#9ece6a)$nodejs[](#9ece6a bg:#f7768e)$time[ ](#f7768e)";
      right_format = "$aws";

      aws = {
        format = "[](#1a1b26)[ $symbol$profile(@$region) ]($style)[](#1a1b26)";
        symbol = "";
        style = "bg:#1a1b26 fg:#82aaff";
      };

      username = {
        show_always = true;
        format = "[$user ]($style)";
        style_user = "bg:#82aaff fg:#1a1b26";
        style_root = "bg:#82aaff fg:#1a1b26";
      };

      directory = {
        format = "[ $path ]($style)";
        style = "bg:#bb9af7 fg:#1a1b26";
        truncation_length = 1;
        truncation_symbol = "";
        truncate_to_repo = false;
      };

      git_branch = {
        symbol = "";
        format = "[  ($branch) ]($style)";
        style = "bg:#bb9af7 fg:#1a1b26";
      };

      git_status = {
        style = "bg:#bb9af7 fg:#1a1b26";
        format = "[( $stashed$ahead_behind)]($style)";
        stashed = "$count";
        ahead = "↑";
        behind = "↓";
        diverged = "⇕";
        up_to_date = "";
        conflicted = "";
        untracked = "";
        modified = "";
        staged = "";
        renamed = "";
        deleted = "";
        typechanged = "";
        worktree_added = "";
        worktree_deleted = "";
      };

      nodejs = {
        symbol = "";
        format = "[ $symbol 7.2.10-1-cachyos ]($style)";
        style = "bg:#9ece6a fg:#1a1b26";
      };

      time = {
        disabled = false;
        format = "[ ♥ $time ]($style)";
        time_format = "%R";
        style = "bg:#f7768e fg:#1a1b26";
      };
    };
  };
}
