{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.thunar;
in
{
  options.cnix.programs.thunar.enable = mkEnableOption "Enables thunar file manager";

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

    environment.systemPackages = with pkgs; [
      file-roller
    ];
  };
}
