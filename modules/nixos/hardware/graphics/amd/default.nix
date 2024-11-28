{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types mkEnableOption mkMerge;
  cfg = config.nixos.hardware.graphics.amd;
in {
  options = {
    nixos.hardware.graphics.amd = {
      enable = mkEnableOption "AMD graphics support";

      packageSet = mkOption {
        type = types.enum ["standard" "chaotic"];
        default = "standard";
        description = ''
          Which set of AMD graphics packages to use:
          - standard: Additional AMD-specific tools and utilities
          - chaotic: Chaotic Mesa git version with additional optimizations
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # Base configuration
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    }

    # Standard Package Set
    (mkIf (cfg.packageSet == "standard") {
      hardware.graphics.extraPackages = with pkgs; [
        libva
        vaapiVdpau
        libvdpau-va-gl
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
      ];
      hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [
        vaapiVdpau
        libvdpau-va-gl
      ];
      environment.systemPackages = with pkgs; [
        vulkan-tools
        wayland
        wayland-protocols
        rocmPackages.rocm-smi
      ];
    })

    # Chaotic Package Set
    (mkIf (cfg.packageSet == "chaotic") {
      chaotic = {
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
            vulkanPackages_latest.vulkan-loader
            vulkanPackages_latest.vulkan-headers
            vulkanPackages_latest.vulkan-validation-layers
            vulkanPackages_latest.vulkan-extension-layer
            vulkanPackages_latest.vulkan-utility-libraries
            vulkanPackages_latest.vulkan-volk
            vulkanPackages_latest.spirv-headers
            vulkanPackages_latest.spirv-tools
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
      environment.systemPackages = with pkgs; [
        vulkanPackages_latest.vulkan-tools
        vulkanPackages_latest.vulkan-tools-lunarg
        vulkanPackages_latest.gfxreconstruct
        vulkanPackages_latest.spirv-cross
        wayland-protocols_git
        wayland_git
        scx.rustscheds
        rocmPackages.rocm-smi
      ];
    })
  ]);
}
