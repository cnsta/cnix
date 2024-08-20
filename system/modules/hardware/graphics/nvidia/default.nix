{
  pkgs,
  config,
  lib,
  ...
}: let
  vulkanDriverFiles = [
    "${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.x86_64.json"
    "${config.hardware.nvidia.package.lib32}/share/vulkan/icd.d/nvidia_icd.i686.json"
  ];
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    export VK_DRIVER_FILES="${builtins.concatStringsSep ":" vulkanDriverFiles}"
    exec "$@"
  '';

  inherit (lib) types mkIf mkEnableOption mkOption;
  cfg = config.modules.hardware.graphics.nvidia;
in {
  options = {
    modules.hardware.graphics.nvidia = {
      enable = mkEnableOption "Enables NVidia graphics";
      package = mkOption {
        type = types.enum ["stable" "beta"];
        default = "stable";
        description = "Choose between the stable or beta NVidia driver package";
      };
    };
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
          nvidia-offload
          vulkan-tools
        ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
      nvidia = {
        package =
          if cfg.package == "beta"
          then config.boot.kernelPackages.nvidiaPackages.beta
          else config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;
        powerManagement = {
          enable = false;
          finegrained = false;
        };
        open = true;
        nvidiaSettings = true;
      };
    };
  };
}
