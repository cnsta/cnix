{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.systemModules.studio.blender;
in {
  options = {
    systemModules.studio.blender = {
      enable = mkEnableOption "Enables Blender";
      hip.enable = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use the HIP-enabled version of Blender (for AMD GPUs).";
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      (
        if cfg.hip.enable
        then pkgs.blender-hip
        else pkgs.blender
      )
    ];
  };
}
