{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  packageNames = map (p: p.pname or p.name or null) config.home.packages;
  hasPackage = name: lib.any (x: x == name) packageNames;
  hasEza = hasPackage "eza";
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
      zsh-abbr = {
        enable = true;
        abbreviations = {
          extract = "extract.sh";
          nixclean = "nh clean all --keep 3";
          nixdev = "nix develop ~/.nix-config -c $SHELL";
          nixup = "nh os switch -H $HOST";
          nixupn = "nh os switch -n -H $HOST";
          nixupv = "nh os switch -v --show-trace -H $HOST";
          nixupvn = "nh os switch -n -v --show-trace -H $HOST";
          flakeup = "nix flake update";
        };
      };
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../../";
        "...." = "cd ../../../";
        "....." = "cd ../../../../";
        "......" = "cd ../../../../../";
        nixconfig = "cd /home/$USER/.nix-config/";
        homemodules = "$EDITOR /home/$USER/.nix-config/users/$USER/modules/{$HOST}mod.nix";
        hmod = "$EDITOR /home/$USER/.nix-config/users/$USER/modules/{$HOST}mod.nix";
        nixsettings = "$EDITOR /home/$USER/.nix-config/hosts/$HOST/settings.nix";
        nset = "$EDITOR /home/$USER/.nix-config/hosts/$HOST/settings.nix";
        nixosmodules = "$EDITOR /home/$USER/.nix-config/hosts/$HOST/modules.nix";
        nmod = "$EDITOR /home/$USER/.nix-config/hosts/$HOST/modules.nix";
        ls = mkIf hasEza "eza";
        tree = mkIf hasEza "eza --tree --icons=always";
        # Clear screen and scrollback
        clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
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
