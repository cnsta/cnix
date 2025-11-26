{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    types
    mkEnableOption
    ;
  cfg = config.nixos.services.xserver;
in
{
  options = {
    nixos.services.xserver = {
      enable = mkEnableOption "Enables xserver";
      videoDrivers = mkOption {
        type = types.listOf (
          types.enum [
            "amdgpu"
            "nvidia"
          ]
        );
        default = [ "amdgpu" ];
        description = "The names of the video drivers the configuration supports";
      };
      xkbLayout = mkOption {
        type = types.str;
        default = "se";
        description = "X keyboard layout, or multiple keyboard layouts separated by commas.";
      };
    };
  };
  config = mkIf cfg.enable {
    services.xserver = {
      videoDrivers = cfg.videoDrivers;
      xkb.layout = cfg.xkbLayout;
    };
  };
}
