{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.cli.zsh;
  inherit (lib.meta) getExe;
  inherit (pkgs) eza bat;
in {
  options = {
    home.cli.zsh.enable = mkEnableOption "Enables zsh home configuration";
  };
  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        cat = "${getExe bat} --style=plain";
        ls = "${getExe eza} -h --git --icons --color=auto --group-directories-first -s extension";
        la = "${getExe eza} -lah --tree";
        tree = "${getExe eza} --tree --icons=always";
        extract = "extract.sh";
        usermodules = "$EDITOR /home/$USER/.nix-config/users/$USER/modules.nix";
        umod = "$EDITOR /home/$USER/.nix-config/users/$USER/modules.nix";
        systemmodules = "$EDITOR /home/$USER/.nix-config/hosts/$HOST/modules.nix";
        smod = "$EDITOR /home/$USER/.nix-config/hosts/$HOST/modules.nix";
        nixcleanboot = "sudo nix run /home/$USER/.nix-config#cleanup-boot";
        nixclean = "nh clean all --keep 3";
        nixdev = "nix develop ~/.nix-config -c $SHELL";
        nixconfig = "cd /home/$USER/.nix-config/";
        ll = "ls -l";
        nixupdate = "nh os switch -v -H $HOST";
        nixup = "nh os switch -H $HOST";
        flakeupdate = "nh os switch -u -v -H $HOST";
        flakeup = "nh os switch -u -H $HOST";
        ".." = "cd ..";
        "..." = "cd ../../";
        "...." = "cd ../../../";
        "....." = "cd ../../../../";
        "......" = "cd ../../../../../";
      };
      history = {
        size = 1000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
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
        PROMPT='%F{red}DEV%f%F{143}%~%f $(git_prompt_info)$(virtualenv_prompt_info)
        %F{143}$ '
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
  };
}
