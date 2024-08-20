{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.utils.misc;
in {
  options = {
    modules.utils.misc.enable = mkEnableOption "Enables miscellaneous pacakges";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nodejs_22
      ripgrep
      fd
      beekeeper-studio
    ];
  };
}
