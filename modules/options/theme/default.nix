{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  bgs = {
    wallpaper_1 = "~/media/images/bg_1.jpg";
    wallpaper_2 = "~/media/images/bg_2.jpg";
    wallpaper_3 = "~/media/images/bg_3.jpg";
  };
  bgList = builtins.attrNames bgs;
in {
  options.theme = {
    background = {
      lockscreen = mkOption {
        type = types.enum bgList;
        apply = name: bgs.${name};
        example = "wallpaper_2";
      };
      desktop = mkOption {
        type = types.enum bgList;
        apply = name: bgs.${name};
        example = "wallpaper_1";
      };
    };
  };
}
