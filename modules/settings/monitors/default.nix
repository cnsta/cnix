{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.cnix.settings.monitors = mkOption {
    type = types.listOf (
      types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            example = "DP-1";
          };
          width = mkOption {
            type = types.ints.positive;
            example = 1920;
          };
          height = mkOption {
            type = types.ints.positive;
            example = 1080;
          };
          refreshRate = mkOption {
            type = types.str;
            default = "60";
          };
          adaptiveSync = mkOption {
            type = types.bool;
            default = false;
          };
          customMode = mkOption {
            type = types.bool;
            default = false;
          };
          transform = mkOption {
            type = types.int;
            default = 0;
          };
          bitDepth = mkOption {
            type = types.nullOr (types.enum [8 10]);
            default = null;
            example = 10;
          };
          position = mkOption {
            type = types.str;
            default = "auto";
          };
          scale = mkOption {
            type = types.str;
            default = "1";
          };
          enable = mkOption {
            type = types.bool;
            default = true;
          };
          workspace = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
        };
      }
    );
    default = [];
  };
}
