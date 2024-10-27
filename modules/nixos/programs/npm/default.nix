{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.npm;
in {
  options = {
    nixos.programs.npm.enable = mkEnableOption "Enables npm";
  };
  config = mkIf cfg.enable {
    programs.npm = {
      enable = true;
    };
  };
}
