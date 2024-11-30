{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.nixos.system.fonts;
in {
  options = {
    nixos.system.fonts = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable various font packages";
      };
    };
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code-symbols
      font-awesome
      recursive
      input-fonts
      source-code-pro
      nerd-fonts.jetbrains-mono
      ibm-plex
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.iosevka
      nerd-fonts._3270
      nerd-fonts.droid-sans-mono
      nerd-fonts.ubuntu-mono
      nerd-fonts.overpass
      nerd-fonts.monoid
      nerd-fonts.mononoki
      nerd-fonts.hack
    ];
  };
}
