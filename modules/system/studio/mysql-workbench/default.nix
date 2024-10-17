{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.studio.mysql-workbench;
in {
  options = {
    system.studio.mysql-workbench.enable = mkEnableOption "Enables MySQL Workbench";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mysql-workbench
    ];
  };
}
