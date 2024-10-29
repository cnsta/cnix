{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.nixos.services.xserver;
in {
  options = {
    nixos.services.xserver = {
      videoDrivers = mkOption {
        type = types.listOf (types.enum ["amdgpu" "nvidia"]);
        default = ["amdgpu"];
        description = "The names of the video drivers the configuration supports";
      };
      xkbLayout = mkOption {
        type = types.str;
        default = "se";
        description = "X keyboard layout, or multiple keyboard layouts separated by commas.";
      };
    };
  };
  config = {
    services.xserver = {
      enable = true;
      videoDrivers = cfg.videoDrivers;
      xkb.layout = cfg.xkbLayout;
    };
  };
}
