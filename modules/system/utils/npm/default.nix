{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.utils.npm;
in {
  options = {
    system.utils.npm.enable = mkEnableOption "Enables npm";
  };
  config = mkIf cfg.enable {
    programs.npm = {
      enable = true;
    };
  };
}
