{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  cfg = config.cnix.programs.tmux;
in
{
  options.cnix.programs.tmux.enable = mkEnableOption "tmux, terminal multiplexer";

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      clock24 = true;
      baseIndex = 1;
      escapeTime = 10;
      historyLimit = 50000;
      aggressiveResize = true;
      terminal = "tmux-256color";
      extraConfig = ''
        set -g default-command "${pkgs.fish}/bin/fish"
        set -g mouse on
        set -ga terminal-overrides ",*256col*:Tc"
        set -s set-clipboard on
        bind -T copy-mode-vi v send -X begin-selection
        bind -T copy-mode-vi y send -X copy-pipe-and-cancel
        set -g renumber-windows on
      '';
    };
  };
}
