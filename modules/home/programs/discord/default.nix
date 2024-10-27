{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.discord;
in {
  options = {
    home.programs.discord.enable = mkEnableOption "Enables discord";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [vesktop];

    xdg.configFile."vesktop/themes/base16.css".text =
      /*
      css
      */
      ''
        /**
             * @name Material Gruvbox
             * @.
             * @author Costeer
             * @version 1.5.0
             * @website https://github.com/Costeer
             * @source https://github.com/Costeer/Gruvbox-Material-Themes
            */

        @import url(https://mwittrien.github.io/BetterDiscordAddons/Themes/DiscordRecolor/DiscordRecolor.css);

        :root {
          --accentcolor: 137, 180, 130;
          --accentcolor2: 211, 134, 155;
          --linkcolor: 125, 174, 163;
          --mentioncolor: 211, 134, 155;
          --textbrightest: 221, 199, 161;
          --textbrighter: 212, 190, 152;
          --textbright: 168, 153, 132;
          --textdark: 146, 131, 116;
          --textdarker: 146, 131, 116;
          --textdarkest: 80, 80, 80;
          --font: Input Sans Narrow;
          --main-font: Input Sans Narrow;
          --code-font: Input Mono Compressed;
          --backgroundaccent: 80, 73, 69;
          --backgroundprimary: 60, 56, 54;
          --backgroundsecondary: 50, 48, 47;
          --backgroundsecondaryalt: 40, 40, 40;
          --backgroundtertiary: 29, 32, 33;
          --backgroundfloating: 20, 22, 23;
          --settingsicons: 1;
        }

      '';
  };
}
