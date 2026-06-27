{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.cnix.programs.firefox;
in
  with lib; {
    options.cnix.programs.firefox.enable = mkEnableOption "Enables firefox";

    config = mkIf cfg.enable {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox;
      };
    };
  }
