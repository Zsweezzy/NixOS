{ lib, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = lib.fileContents ./fish/config.fish;
  };
  xdg.configFile."fish/conf.d/ssh-agent.fish".source = ./fish/conf.d/ssh-agent.fish;
  xdg.configFile."fish/completions".source = ./fish/completions;

  programs.atuin.enable = true;
  programs.zoxide.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  services.ssh-agent.enable = true;

  # config.fish already runs `starship init fish`.
  programs.starship.enableFishIntegration = false;
}
