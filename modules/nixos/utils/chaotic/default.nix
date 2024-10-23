{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mkMerge;
  cfg = config.nixos.utils.chaotic;
in {
  options = {
    nixos.utils.chaotic = {
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
      chaotic.scx.enable = true;
    }
    (mkIf cfg.amd.enable {
      # AMD-specific configuration
      chaotic = {
        scx.scheduler = "scx_lavd";
        mesa-git = {
          enable = true;
          extraPackages = with pkgs; [
            libva
            libvdpau-va-gl
            vaapiVdpau
            libdrm_git
            latencyflex-vulkan
            mesa_git
            mesa_git.opencl
            vulkanPackages_latest.gfxreconstruct
            vulkanPackages_latest.spirv-cross
            vulkanPackages_latest.spirv-headers
            vulkanPackages_latest.spirv-tools
            vulkanPackages_latest.vulkan-extension-layer
            vulkanPackages_latest.vulkan-headers
            vulkanPackages_latest.vulkan-loader
            vulkanPackages_latest.vulkan-tools
            vulkanPackages_latest.vulkan-tools-lunarg
            vulkanPackages_latest.vulkan-utility-libraries
            vulkanPackages_latest.vulkan-validation-layers
            vulkanPackages_latest.vulkan-volk
          ];
          extraPackages32 = with pkgs.pkgsi686Linux; [
            pkgs.mesa32_git
            pkgs.mesa32_git.opencl
            libdrm32_git
            libva
            libvdpau-va-gl
            vaapiVdpau
          ];
        };
      };
    })
  ]);
}
