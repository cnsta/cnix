{ config, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      # character = {
      #   success_symbol = "[➜](bold green)";
      #   error_symbol = "[➜](bold red)";
      # };
    };
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      nixconfig = "cd /home/cnst/.nix-config/";
      ll = "ls -l";
      nixupdate = "sudo nixos-rebuild switch --flake .#cnix";
      flakeupdate = "nix flake update";
    };
    history = {
      size = 1000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "thefuck"
      ];
      theme = "robbyrussell";
    };
    initExtra = ''
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'
      eval $(thefuck --alias)
      eval $(thefuck --alias FUCK)

      eval "$(starship init zsh)"
    '';
  };
}
