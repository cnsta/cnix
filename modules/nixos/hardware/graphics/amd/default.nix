{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mkMerge optional;
  cfg = config.nixos.hardware.graphics.amd;
in {
  options = {
    nixos.hardware.graphics.amd = {
      enable = mkEnableOption "Enables AMD graphics";

      extraPackages = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to install AMD-specific extra packages.";
      };

      chaotic = {
        enable = mkEnableOption "Enables chaotic mesa version";
        extraPackages = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to install AMD-specific chaotic extra packages.";
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = !(cfg.extraPackages && cfg.chaotic.extraPackages);
          message = ''
            Only one type of extraPackages can be set to true at the same time.
          '';
        }
      ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = optional cfg.extraPackages (with pkgs; [
          libva
          vaapiVdpau
          libvdpau-va-gl
          amdvlk
          vulkan-tools
        ]);

        extraPackages32 = optional cfg.extraPackages (with pkgs.pkgsi686Linux; [
          vaapiVdpau
          libvdpau-va-gl
        ]);
      };
    }
    (mkIf cfg.chaotic.enable (mkMerge [
      {
        chaotic.scx.enable = true;
      }
      (mkIf cfg.chaotic.extraPackages {
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
    ]))
  ]);
}
