{config, ...}: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      usermodules = "nvim /home/toothpick/.nix-config/home/users/toothpick/modules.nix";
      umod = "nvim /home/toothpick/.nix-config/home/users/toothpick/modules.nix";
      systemmodules = "nvim /home/toothpick/.nix-config/hosts/toothpc/modules.nix";
      smod = "nvim /home/toothpick/.nix-config/hosts/toothpc/modules.nix";
      nixclean = "sudo nix run .#cleanup-boot";
      nixdev = "nix develop ~/.nix-config -c $SHELL";
      nixconfig = "cd /home/toothpick/.nix-config/";
      ll = "ls -l";
      nixupdate = "nh os switch -v -H toothpc && sudo nix run .#cleanup-boot";
      nixup = "nh os switch -H toothpc && sudo nix run .#cleanup-boot";
      flakeupdate = "nh os switch -u -v -H toothpc && sudo nix run .#cleanup-boot";
      flakeup = "nh os switch -u -H toothpc && sudo nix run .#cleanup-boot";
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

      PROMPT='%F{143}%~%f $(git_prompt_info)$(virtualenv_prompt_info)
      %F{143}$ '

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