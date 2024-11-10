{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.thunar;
in {
  options = {
    home.programs.thunar.enable = mkEnableOption "Enables thunar file manager";
  };
  config = mkIf cfg.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    programs.xfconf.enable = true;
    services.tumbler.enable = true;

    environment.systemPackages = [pkgs.file-roller];
  };
}
