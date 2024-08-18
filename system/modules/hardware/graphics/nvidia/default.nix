{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.hardware.graphics.nvidia;
in {
  options = {
    modules.hardware.graphics.nvidia.enable = mkEnableOption "Enables NVidia graphics";
  };
  config = mkIf cfg.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          libva
          vaapiVdpau
          libvdpau-va-gl
          intel-media-driver
          nvidia-vaapi-driver
        ];
      };
      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        # package = config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;
        powerManagement = {
          enable = false;
          finegrained = false;
        };
        open = false;
        nvidiaSettings = true;
      };
    };
  };
}
