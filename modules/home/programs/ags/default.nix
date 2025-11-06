{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.ags;
in
{
  imports = [ inputs.ags.homeManagerModules.default ];
  options = {
    home.programs.ags.enable = mkEnableOption "Enables ags";
  };
  config = mkIf cfg.enable {
    programs.ags = {
      enable = true;

      # symlink to ~/.config/ags
      configDir = ../ags;

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.battery
        fzf
        io
        astal3
        astal4
        apps
        auth
        battery
        bluetooth
        greet
        hyprland
        mpris
        network
        notifd
        powerprofiles
        tray
        wireplumber
      ];
    };
  };
}
