{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.hardware.graphics.amd;
in {
  options = {
    modules.hardware.graphics.amd.enable = mkEnableOption "Enables AMD graphics";
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
          amdvlk

          # mesa
          mesa

          # vulkan
          # vulkan-tools
          # vulkan-loader
          # vulkan-validation-layers
          # vulkan-extension-layer
        ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
    };
  };
}
