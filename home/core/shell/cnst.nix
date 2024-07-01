{config, ...}: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      nixconfig = "cd /home/cnst/.nix-config/";
      ll = "ls -l";
      nixupdate = "sudo nixos-rebuild switch -v --show-trace --flake .#cnix";
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
    profileExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';
    initExtraFirst = ''
      autoload -U colors && colors
    '';
    initExtra = ''
      ZSH_THEME_GIT_PROMPT_PREFIX="%F{66}(%F{66}"
      ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
      ZSH_THEME_GIT_PROMPT_DIRTY="%F{66}) %F{172}%1{✗%}"
      ZSH_THEME_GIT_PROMPT_CLEAN="%F{66)"

      ZSH_THEME_RUBY_PROMPT_PREFIX="%F{66}‹"
      ZSH_THEME_RUBY_PROMPT_SUFFIX="›%f"

      PROMPT='%F{66}%c%f $(git_prompt_info)$(virtualenv_prompt_info)
      %F{66}➜ '

      RPROMPT='$(ruby_prompt_info)'

      VIRTUAL_ENV_DISABLE_PROMPT=0
      ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX=" %F{66}🐍 "
      ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="%f"
      ZSH_THEME_VIRTUALENV_PREFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX
      ZSH_THEME_VIRTUALENV_SUFFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX

      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'
      eval $(thefuck --alias)
      eval $(thefuck --alias FUCK)
    '';
  };
}
