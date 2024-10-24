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
      extraPortals = mkOption {
        type = types.listOf types.package;
        default = [pkgs.xdg-desktop-portal-gtk];
        description = "List of extra portals to include.";
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = cfg.xdgOpenUsePortal;
      config = {
        common.default = ["gtk"];
        hyprland.default = ["gtk" "hyprland"];
      };
      extraPortals = cfg.extraPortals;
    };
  };
}