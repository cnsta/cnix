{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.utils.zsh;
in {
  options = {
    system.utils.zsh.enable = mkEnableOption "Enables zsh shell";
  };
  config = mkIf cfg.enable {
    programs.zsh.enable = cfg.enable;
  };
}
