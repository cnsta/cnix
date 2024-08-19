{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.utils.npm;
in {
  options = {
    modules.utils.npm.enable = mkEnableOption "Enables npm";
  };
  config = mkIf cfg.enable {
    programs.npm = {
      enable = true;
    };
  };
}
