{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.utils.npm;
in {
  options = {
    nixos.utils.npm.enable = mkEnableOption "Enables npm";
  };
  config = mkIf cfg.enable {
    programs.npm = {
      enable = true;
    };
  };
}
