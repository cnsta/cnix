{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.utils.mpv;
in {
  options = {
    home.utils.mpv.enable = mkEnableOption "Enables mpv";
  };
  config = mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      defaultProfiles = ["gpu-hq"];
      scripts = [pkgs.mpvScripts.mpris];
    };
  };
}
