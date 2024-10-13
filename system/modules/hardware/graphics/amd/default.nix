{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.hardware.graphics.amd;
in {
  options = {
    systemModules.hardware.graphics.amd.enable = mkEnableOption "Enables AMD graphics";
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
          vulkan-tools
        ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
    };
  };
}
