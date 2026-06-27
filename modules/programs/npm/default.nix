{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.npm;
in {
  options.cnix.programs.npm.enable = mkEnableOption "Enables npm";

  config = mkIf cfg.enable {
    programs.npm = {
      enable = true;
    };
  };
}
