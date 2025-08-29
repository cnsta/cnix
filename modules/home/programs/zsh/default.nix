{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.meta) getExe;
  inherit (pkgs) eza bat;
  cfg = config.home.programs.zsh;
in
{
  options = {
    home.programs.zsh.enable = mkEnableOption "Enables zsh home configuration";
  };
  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        cat = "${getExe bat} --style=plain";
        ls = "${getExe eza} -h --git --icons --color=auto --group-directories-first -s extension";
        ll = "${getExe eza} -l --git --icons --color=auto --group-directories-first -s extension";
        lat = "${getExe eza} -lah --tree";
        la = "${getExe eza} -lah";
        tree = "${getExe eza} --tree --icons=always";
        extract = "extract.sh";
        homemodules = "$EDITOR /home/$USER/.nix-config/users/$USER/modules/{$HOST}mod.nix";
        hmod = "$EDITOR /home/$USER/.nix-config/users/$USER/modules/{$HOST}mod.nix";
        nixsettings = "$EDITOR /home/$USER/.nix-config/hosts/$HOST/settings.nix";
        nset = "$EDITOR /home/$USER/.nix-config/hosts/$HOST/settings.nix";
        nixosmodules = "$EDITOR /home/$USER/.nix-config/hosts/$HOST/modules.nix";
        nmod = "$EDITOR /home/$USER/.nix-config/hosts/$HOST/modules.nix";
        nixcleanboot = "sudo nix run /home/$USER/.nix-config#cleanup-boot";
        nixclean = "nh clean all --keep 3";
        nixdev = "nix develop ~/.nix-config -c $SHELL";
        nixconfig = "cd /home/$USER/.nix-config/";
        nixup = "nh os switch -H $HOST";
        nixupv = "nh os switch -v -H $HOST";
        flakeup = "nix flake update";
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
      initContent = ''
        autoload -U colors && colors
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

        setopt PROMPT_CR
        setopt PROMPT_SP
        export PROMPT_EOL_MARK=""

        microfetch
      '';
    };
  };
}
