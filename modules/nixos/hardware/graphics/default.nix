{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf mkMerge;

  cfg = config.nixos.hardware.graphics;
  vendor = cfg.vendor;

  # Common packages used across all vendors
  commonPackages = with pkgs; [
    libva
    vaapiVdpau
    libvdpau-va-gl
    libGL
  ];
  commonPackages32 = with pkgs.pkgsi686Linux; [
    libva
    vaapiVdpau
    libvdpau-va-gl
  ];

  # Mesa Vulkan packages (used by AMD & Intel only)
  mesaVulkanPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
    vulkan-utility-libraries
  ];

  # Extra desktop utilities
  tools = with pkgs; [
    vulkan-tools
    wayland
    wayland-protocols
    libGL
  ];

  nvidiaOffloadScript = pkgs.writeShellScriptBin "nvidia-offload" ''
    export LIBVA_DRIVER_NAME=nvidia
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __GL_VRR_ALLOWED=1
    export XDG_SESSION_TYPE=wayland
    export NVD_BACKEND=direct
    export ELECTRON_OZONE_PLATFORM_HINT=auto
    exec "$@"
  '';
in {
  options.nixos.hardware.graphics = {
    enable = mkEnableOption "Enable general graphics support";

    vendor = mkOption {
      type = types.enum ["amd" "intel" "nvidia"];
      default = "amd";
      description = "GPU vendor to configure support for.";
    };

    nvidia = {
      open.enable = mkEnableOption "Enable NVidia open drivers";
      package = mkOption {
        type = types.enum ["stable" "beta" "production" "latest"];
        default = "stable";
        description = "NVidia driver package to use.";
      };
    };
  };

  config = mkIf cfg.enable (
    mkMerge [
      {
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };
      }

      # AMD-specific configuration
      (mkIf (vendor == "amd") {
        hardware.amdgpu.overdrive.enable = true;
        hardware.graphics.extraPackages = commonPackages ++ mesaVulkanPackages;
        hardware.graphics.extraPackages32 = commonPackages32;
        environment.systemPackages = tools;
      })

      # Intel-specific configuration
      (mkIf (vendor == "intel") {
        hardware.graphics.extraPackages =
          commonPackages
          ++ mesaVulkanPackages
          ++ (with pkgs; [
            vpl-gpu-rt
            intel-media-driver
            intel-compute-runtime
          ]);
        hardware.graphics.extraPackages32 = commonPackages32;
        environment.systemPackages = tools;
      })

      # Nvidia-specific configuration
      (mkIf (vendor == "nvidia") {
        hardware.graphics.extraPackages =
          commonPackages
          ++ (with pkgs; [
            nvidiaOffloadScript
            intel-media-driver
            nvidia-vaapi-driver
            vulkan-tools
          ]);
        hardware.graphics.extraPackages32 = commonPackages32;
        environment.systemPackages = with pkgs; [
          egl-wayland
          libGL
        ];

        hardware.nvidia = {
          package =
            if cfg.nvidia.package == "beta"
            then config.boot.kernelPackages.nvidiaPackages.beta
            else if cfg.nvidia.package == "latest"
            then config.boot.kernelPackages.nvidiaPackages.latest
            else if cfg.nvidia.package == "production"
            then config.boot.kernelPackages.nvidiaPackages.production
            else config.boot.kernelPackages.nvidiaPackages.stable;

          modesetting.enable = true;
          powerManagement.enable = false;
          powerManagement.finegrained = false;
          open = cfg.nvidia.open.enable;
          nvidiaSettings = true;
        };
      })
    ]
  );
}
