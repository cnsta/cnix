{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mkMerge;
  cfg = config.modules.utils.chaotic;
in {
  options = {
    modules.utils.chaotic = {
      enable = mkEnableOption "Enables Chaotic AUR packages";
      amd.enable = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to install AMD-specific settings.";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # Base configuration when Chaotic is enabled
      chaotic.scx.enable = true;
    }
    (mkIf cfg.amd.enable {
      # AMD-specific configuration
      chaotic.mesa-git = {
        enable = true;
        extraPackages = with pkgs; [
          mesa_git.opencl
          intel-media-driver
          intel-ocl
          vaapiIntel
        ];
        extraPackages32 = with pkgs; [
          mesa32_git.opencl
          intel-media-driver
          vaapiIntel
        ];
      };
    })
  ]);
}
