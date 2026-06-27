{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.mysql-workbench;
in {
  options.cnix.programs.mysql-workbench.enable = mkEnableOption "Enables MySQL Workbench";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mysql-workbench
    ];
  };
}
