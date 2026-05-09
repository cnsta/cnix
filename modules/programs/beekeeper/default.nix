{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.beekeeper;
in
{
  options = {
    cnix.programs.beekeeper.enable = mkEnableOption "Enables Beekeeper Studio";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      beekeeper-studio
    ];
  };
}
