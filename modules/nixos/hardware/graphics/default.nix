{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    mkMerge
    mkForce
    types
    flatten
    concatMap
    ;

  cfg = config.nixos.hardware.graphics;

  commonPackages = with pkgs; [
    libva
    libva-vdpau-driver
    libvdpau-va-gl
  ];

  commonPackages32 = with pkgs.pkgsi686Linux; [
    libva
    libva-vdpau-driver
    libvdpau-va-gl
  ];

  mesaVulkanPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
    vulkan-utility-libraries
  ];

  tools = with pkgs; [
    vulkan-tools
    wayland
    wayland-protocols
  ];

  hasVendor = vendor: builtins.elem vendor cfg.vendors;
  nonNvidia = builtins.any (v: v != "nvidia") cfg.vendors;
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
    (mkIf nonNvidia {
      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = flatten (
            concatMap (
              vendor:
              if vendor == "amd" then
                commonPackages ++ mesaVulkanPackages
              else if vendor == "intel" then
                commonPackages
                ++ mesaVulkanPackages
                ++ (with pkgs; [
                  vpl-gpu-rt
                  intel-media-driver
                  intel-compute-runtime
                  intel-vaapi-driver
                ])
              else
                [ ]
            ) cfg.vendors
          );
          extraPackages32 = flatten (concatMap (_: commonPackages32) cfg.vendors);
        };
      };

      environment.systemPackages = flatten (
        concatMap (
          vendor:
          if vendor == "amd" then
            tools
            ++ (with pkgs; [
              # rocmPackages.rpp
              # rocmPackages.clr
            ])
          else if vendor == "intel" then
            tools
          else if vendor == "nvidia" then
            with pkgs;
            [
              egl-wayland
              libGL
              intel-media-driver
              nvidia-vaapi-driver
              vulkan-tools
            ]
          else
            [ ]
        ) cfg.vendors
      );
    })

    (mkIf (hasVendor "nvidia") {
      hardware.nvidia = {
        package =
          if cfg.nvidia.package == "beta" then
            config.boot.kernelPackages.nvidiaPackages.beta
          else if cfg.nvidia.package == "latest" then
            config.boot.kernelPackages.nvidiaPackages.latest
          else if cfg.nvidia.package == "production" then
            config.boot.kernelPackages.nvidiaPackages.production
          else
            config.boot.kernelPackages.nvidiaPackages.stable;

        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = cfg.nvidia.open;
        nvidiaSettings = true;
      };
    })
  ];
}
