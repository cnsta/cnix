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
    environment.systemPackages = with pkgs; [
      xwayland-satellite-unstable
    ];
    systemd.user.services.niri-flake-polkit.enable = false;
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
  };
}
