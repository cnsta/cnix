{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.studio.mysql-workbench;
in {
  options = {
    systemModules.studio.mysql-workbench.enable = mkEnableOption "Enables MySQL Workbench";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mysql-workbench
    ];
  };
}
