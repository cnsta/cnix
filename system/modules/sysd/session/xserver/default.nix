{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.systemModules.sysd.session.xserver;
in {
  options = {
    systemModules.sysd.session.xserver = {
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
      videoDrivers = cfg.videoDrivers;
      xkb.layout = cfg.xkbLayout;
    };
  };
}
