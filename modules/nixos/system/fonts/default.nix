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
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code-symbols
      font-awesome
      recursive
      input-fonts
      (pkgs.nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "FiraCode"
          "FiraMono"
          "Iosevka"
          "3270"
          "DroidSansMono"
          "SourceCodePro"
          "UbuntuMono"
          "Overpass"
          "Monoid"
          "Mononoki"
          "Hack"
          "IBMPlexMono"
        ];
      })
    ];
  };
}
