{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.nixos.system.xdg;
in {
  options = {
    nixos.system.xdg = {
      enable = mkEnableOption "Enable XDG portal.";
      xdgOpenUsePortal = mkOption {
        type = types.bool;
        default = true;
        description = "Use xdg-open via the portal.";
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = cfg.xdgOpenUsePortal;
      config = {
        common.default = ["gtk"];
        hyprland.default = ["hyprland" "gtk"];
      };
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
  };
}
