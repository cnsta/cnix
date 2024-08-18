{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.xserver.nvidia;
in {
  options = {
    modules.sysd.xserver.nvidia.enable = mkEnableOption "Enables xserver with nvidia";
  };
  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
      xkb.layout = "se";
    };
  };
}
