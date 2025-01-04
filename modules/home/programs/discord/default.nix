{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption types;
  variantMapping = {
    stable = {
      dir = "discord";
      package = pkgs.discord;
    };
    ptb = {
      dir = "discordptb";
      package = pkgs.discord-ptb;
    };
    canary = {
      dir = "discordcanary";
      package = pkgs.discord-canary.override {withOpenASAR = true;};
    };
    vesktop = {
      dir = "vesktop";
      package = pkgs.vesktop;
    };
  };
  getVariantConfig = variant:
    if builtins.hasAttr variant variantMapping
    then variantMapping.${variant}
    else throw "Unknown package variant: ${variant}";
  cfg = config.home.programs.discord;
in {
  options = {
    home.programs.discord = {
      enable = mkEnableOption "Enables discord";
      variant = mkOption {
        type = types.enum ["stable" "ptb" "canary" "vesktop"];
        default = "stable";
        description = "Preferred package version to use";
      };
    };
  };
  config = mkIf cfg.enable {
    home = {
      sessionVariables.DISCORD_USER_DATA_DIR = "$HOME/.config/${(getVariantConfig cfg.variant).dir}";
      packages = [(getVariantConfig cfg.variant).package];
    };
    xdg.configFile = mkIf (cfg.variant == "vesktop") {
      "vesktop/themes/base16.css".text =
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
  };
}
