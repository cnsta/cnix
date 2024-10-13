{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.utils.npm;
in {
  options = {
    systemModules.utils.npm.enable = mkEnableOption "Enables npm";
  };
  config = mkIf cfg.enable {
    programs.npm = {
      enable = true;
    };
  };
}
