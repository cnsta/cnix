{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cnix.settings.graphics;

  commonDrivers = with pkgs; [
    libva-vdpau-driver
    libvdpau-va-gl
  ];

  userTools = with pkgs; [
    libva # vainfo
    vulkan-tools # vulkaninfo, vkcube
    wayland
    wayland-protocols
  ];

  hasVendor = vendor: builtins.elem vendor cfg.vendors;
in
{
  options.cnix.settings.graphics = {
    vendors = mkOption {
      type = types.listOf (
        types.enum [
          "amd"
          "intel"
          "nvidia"
        ]
      );
      default = [ "amd" ];
      description = "List of GPU vendors to configure support for.";
    };
    nvidia = {
      open = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use nvidia open driver";
      };
      package = mkOption {
        type = types.enum [
          "stable"
          "beta"
          "production"
          "latest"
        ];
        default = "stable";
        description = "Nvidia driver package to use.";
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.vendors != [ ]) {
      hardware.graphics = {
        enable = true;
        enable32Bit = pkgs.stdenv.hostPlatform.isx86_64;
        extraPackages = concatMap (
          vendor:
          if vendor == "amd" then
            commonDrivers
          else if vendor == "intel" then
            commonDrivers
            ++ (with pkgs; [
              vpl-gpu-rt
              intel-media-driver
              intel-compute-runtime
              intel-vaapi-driver
            ])
          else if vendor == "nvidia" then
            (with pkgs; [
              nvidia-vaapi-driver
              egl-wayland
            ])
          else
            [ ]
        ) cfg.vendors;
      };

      environment.systemPackages = userTools;
    })

    (mkIf (hasVendor "nvidia") {
      hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.${cfg.nvidia.package};
        open = cfg.nvidia.open;
        nvidiaSettings = true;
      };
      services.xserver.videoDrivers = mkDefault [ "nvidia" ];
      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        NVD_BACKEND = "direct";
      };
    })
  ];
}
