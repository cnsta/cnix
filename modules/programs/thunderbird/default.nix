{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.thunderbird;
in
{
  options = {
    cnix.programs.thunderbird.enable = mkEnableOption "Enables thunderbird mail client";
  };
  config = mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
    };
  };
}
