{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.utils.zsh;
in {
  options = {
    systemModules.utils.zsh.enable = mkEnableOption "Enables android tools";
  };
  config = mkIf cfg.enable {
    programs.zsh.enable = cfg.enable;
  };
}
