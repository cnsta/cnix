{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mkMerge;
  cfg = config.system.utils.chaotic;
in {
  options = {
    system.utils.chaotic = {
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
          extraPackages32 = with pkgs; [
            mesa32_git
            libdrm32_git
            libva
            vaapiVdpau
          ];
        };
      };
    })
  ]);
}
