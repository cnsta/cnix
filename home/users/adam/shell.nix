{config, ...}: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      usermodules = "nvim /home/adam/.nix-config/home/users/adam/modules.nix";
      umod = "nvim /home/adam/.nix-config/home/users/adam/modules.nix";
      systemmodules = "nvim /home/adam/.nix-config/hosts/adampad/modules.nix";
      smod = "nvim /home/adam/.nix-config/hosts/adampad/modules.nix";
      nixclean = "sudo nix run /home/adam/.nix-config#cleanup-boot";
      nixdev = "nix develop ~/.nix-config -c $SHELL";
      nixconfig = "cd /home/adam/.nix-config/";
      ll = "ls -l";
      nixupdate = "nh os switch -v -H adampad && sudo nix run /home/adam/.nix-config#cleanup-boot";
      nixup = "nh os switch -H adampad && sudo nix run /home/adam/.nix-config#cleanup-boot";
      flakeupdate = "nh os switch -u -v -H adampad && sudo nix run /home/adam/.nix-config#cleanup-boot";
      flakeup = "nh os switch -u -H adampad && sudo nix run /home/adam/.nix-config#cleanup-boot";
    };
    history = {
      size = 1000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        #     "thefuck"
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
      ZSH_THEME_GIT_PROMPT_PREFIX="%F{143}(%F{167}"
      ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
      ZSH_THEME_GIT_PROMPT_DIRTY="%F{143}) %F{202}%1{✗%}"
      ZSH_THEME_GIT_PROMPT_CLEAN="%F{143})"

      ZSH_THEME_RUBY_PROMPT_PREFIX="%F{167}‹"
      ZSH_THEME_RUBY_PROMPT_SUFFIX="›%f"

      # Check if we're in a nix-shell or nix develop environment
      if [[ -n "$IN_NIX_SHELL" ]]; then
      PROMPT='%F{143}%~%f $(git_prompt_info)$(virtualenv_prompt_info)
      %F{red}󰫱󰫲󰬃%f %F{143}$ '
      else
      PROMPT='%F{143}%~%f $(git_prompt_info)$(virtualenv_prompt_info)
      %F{143}$ '
      fi

      RPROMPT='$(ruby_prompt_info)'

      VIRTUAL_ENV_DISABLE_PROMPT=0
      ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX=" %F{66}🐍 "
      ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="%f"
      ZSH_THEME_VIRTUALENV_PREFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX
      ZSH_THEME_VIRTUALENV_SUFFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX

      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'
      microfetch
    '';
  };
}
