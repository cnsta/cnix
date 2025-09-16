{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.niri;
in
{
  options = {
    nixos.programs.niri.enable = mkEnableOption "Enables niri";
  };
  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    environment = {
      variables = {
        NIXOS_OZONE_WL = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      };
      systemPackages = with pkgs; [
        xwayland-satellite-unstable
        wl-clipboard
        wayland-utils
      ];
    };
    systemd.user.services.niri-flake-polkit.enable = false;
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
  };
}
