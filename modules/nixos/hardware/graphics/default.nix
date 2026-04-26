{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixos.hardware.graphics;

  commonPackages = with pkgs; [
    libva-vdpau-driver
    libvdpau-va-gl
  ];

  tools = with pkgs; [
    libva
    vulkan-tools
    wayland
    wayland-protocols
  ];

  hasVendor = vendor: builtins.elem vendor cfg.vendors;
in
{
  options.nixos.hardware.graphics = {
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
        description = "NVidia driver package to use.";
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.vendors != [ ]) {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = concatMap (
          vendor:
          if vendor == "amd" then
            commonPackages
          else if vendor == "intel" then
            commonPackages
            ++ (with pkgs; [
              vpl-gpu-rt
              intel-media-driver
              intel-compute-runtime
              intel-vaapi-driver
            ])
          else if vendor == "nvidia" then
            (with pkgs; [ nvidia-vaapi-driver ])
          else
            [ ]
        ) cfg.vendors;
      };

      environment.systemPackages =
        tools
        ++ concatMap (
          vendor:
          if vendor == "nvidia" then
            (with pkgs; [
              egl-wayland
              libGL
            ])
          else
            [ ]
        ) cfg.vendors;
    })

    (mkIf (hasVendor "nvidia") {
      hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.${cfg.nvidia.package};
        open = cfg.nvidia.open;
        nvidiaSettings = true;
      };
      services.xserver.videoDrivers = mkDefault [ "nvidia" ];
    })
  ];
}
