{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.steam;
in {
  options.cnix.programs.steam.enable = mkEnableOption "Enables steam";

  config = mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
      gamescope = {
        enable = true;
        capSysNice = true;
        args = [
          "--rt"
          "--expose-wayland"
        ];
      };
    };
    environment.systemPackages = with pkgs; [
      protonup-ng
      wine
      winetricks
      wine-wayland
    ];
  };
}
