{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.session.xserver.nvidia;
in {
  options = {
    modules.sysd.session.xserver.nvidia.enable = mkEnableOption "Enables xserver with nvidia";
  };
  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
      xkb.layout = "se";
    };
  };
}
