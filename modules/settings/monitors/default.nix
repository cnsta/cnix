{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.cnix.settings.monitors = mkOption {
    description = ''
      The host's monitors, the single place they are configured. Consumers:
      the river module (kanshi profiles, HDR, bit depth via
      programs.river-delta.outputs) and swaybg (wallpaper per output).
    '';
    type = types.listOf (
      types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            example = "DP-1";
            description = "Connector name, as `wlr-randr` lists it.";
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
            type = types.ints.between 0 7;
            default = 0;
            description = "0 normal, 1–3 rotated 90/180/270, 4–7 the same flipped.";
          };
          bitDepth = mkOption {
            type = types.enum [8 10];
            default = 8;
            example = 10;
          };
          hdr = mkOption {
            type = types.bool;
            default = false;
            description = "HDR (BT.2020/PQ, always 10 bit). Needs the vulkan renderer.";
          };
          position = mkOption {
            type = types.str;
            default = "auto";
            example = "2560x0";
          };
          scale = mkOption {
            type = types.number;
            default = 1;
          };
          enable = mkOption {
            type = types.bool;
            default = true;
          };
          wallpaper = mkOption {
            type = types.nullOr (types.enum ["primary" "secondary"]);
            default = "primary";
            description = "Which cnix.settings.theme.background to show; null for none.";
          };
        };
      }
    );
    default = [];
  };
}
