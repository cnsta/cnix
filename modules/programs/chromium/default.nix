{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.cnix.programs.chromium;
in
{
  options.cnix.programs.chromium.enable = mkEnableOption "Enables chromium";

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
    };
  };
}
