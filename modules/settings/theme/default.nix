{ lib, ... }:
let
  inherit (lib) mkOption types;
  bgList = [
    "wallpaper_1"
    "wallpaper_2"
    "wallpaper_3"
    "wallpaper_4"
    "wallpaper_5"
    "wallpaper_6"
    "wallpaper_7"
    "wallpaper_8"
    "wallpaper_9"
  ];
in
{
  options.settings.theme.background = {
    lockscreen = mkOption {
      type = types.enum bgList;
      example = "wallpaper_1";
    };
    primary = mkOption {
      type = types.enum bgList;
      example = "wallpaper_2";
    };
    secondary = mkOption {
      type = types.nullOr (types.enum bgList);
      default = null;
      example = "wallpaper_3";
    };
  };
}
