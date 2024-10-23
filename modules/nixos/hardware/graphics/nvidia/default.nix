{
  pkgs,
  config,
  lib,
  ...
}: let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export LIBVA_DRIVER_NAME=nvidia
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __GL_VRR_ALLOWED=1
    export XDG_SESSION_TYPE=wayland
    export NVD_BACKEND=direct
    export ELECTRON_OZONE_PLATFORM_HINT=auto
        exec "$@"
  '';
  inherit (lib) types mkIf mkEnableOption mkOption;
  cfg = config.nixos.hardware.graphics.nvidia;
in {
  options = {
    nixos.hardware.graphics.nvidia = {
      enable = mkEnableOption "Enables NVidia graphics";
      package = mkOption {
        type = types.enum ["stable" "beta" "production" "latest"];
        default = "stable";
        description = "Choose between the stable, beta, latest, or production NVidia driver package";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      egl-wayland
    ];
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          nvidia-offload
          libva
          vaapiVdpau
          libvdpau-va-gl
          intel-media-driver
          nvidia-vaapi-driver
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
          else if cfg.package == "latest"
          then config.boot.kernelPackages.nvidiaPackages.latest
          else if cfg.package == "production"
          then config.boot.kernelPackages.nvidiaPackages.prodution
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
