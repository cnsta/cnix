{
  pkgs,
  config,
  lib,
  ...
}: let
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
        open = false;
        nvidiaSettings = true;
      };
    };
  };
}
