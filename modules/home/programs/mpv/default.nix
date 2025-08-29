{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.mpv;
in
{
  options = {
    home.programs.mpv.enable = mkEnableOption "Enables mpv";
  };
  config = mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      defaultProfiles = [ "gpu-hq" ];
      scripts = [ pkgs.mpvScripts.mpris ];
    };
  };
}
