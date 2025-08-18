# Yanked from Misterio77
{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.settings.monitors = mkOption {
    type = types.listOf (
      types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            example = "DP-1";
          };
          width = mkOption {
            type = types.int;
            example = 1920;
          };
          height = mkOption {
            type = types.int;
            example = 1080;
          };
          refreshRate = mkOption {
            type = types.int;
            default = 60;
          };
          transform = mkOption {
            type = types.int;
            default = 0;
          };
          bitDepth = mkOption {
            type = types.nullOr types.int;
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
