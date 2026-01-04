{ lib, bgs, ... }:
let
  inherit (lib) mkOption types;

  bgList = builtins.attrNames bgs.files;
in
{
  options.settings.theme.background = {
    lockscreen = mkOption {
      type = types.enum bgList;
      example = builtins.head bgList;
      description = "Wallpaper name used for the lockscreen";
    };

    primary = mkOption {
      type = types.enum bgList;
      example = builtins.head bgList;
      description = "Primary wallpaper";
    };

    secondary = mkOption {
      type = types.nullOr (types.enum bgList);
      default = null;
      example = if builtins.length bgList > 1 then builtins.elemAt bgList 1 else null;
    };
  };
}
