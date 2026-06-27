{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.cnix.programs.chromium;
in {
  options.cnix.programs.chromium.enable = mkEnableOption "Enables chromium";

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.chromium];
    programs.chromium = {
      enable = true;
    };
  };
}
