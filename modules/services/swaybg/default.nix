{
  config,
  lib,
  pkgs,
  bgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types escapeShellArgs concatMap attrNames filterAttrs;

  cfg = config.cnix.services.swaybg;
  bg = config.cnix.settings.theme.background;

  wanted = filterAttrs (_: name: name != null) cfg.outputs;

  groupFor = output: name: ["-o" output "-i" (bgs.resolve name) "-m" cfg.mode];

  outputArgs = concatMap (o: groupFor o wanted.${o}) (attrNames wanted);

  args = escapeShellArgs outputArgs;
in {
  options.cnix.services.swaybg = {
    enable = mkEnableOption "swaybg wallpaper";

    package = mkOption {
      type = types.package;
      default = pkgs.swaybg;
      defaultText = lib.literalExpression "pkgs.swaybg";
    };

    outputs = mkOption {
      type = types.attrsOf (types.nullOr types.str);
      default = {
        "DP-3" = bg.primary;
        "HDMI-A-1" = bg.secondary;
        "eDP-1" = bg.primary;
        "DVI-D-1" = bg.primary;
      };
      defaultText = lib.literalExpression ''
        {
          "DP-3" = background.primary;
          "HDMI-A-1" = background.secondary;
          "eDP-1" = background.primary;
          "DVI-D-1" = background.primary;
        }
      '';
      example = {"DP-3" = "resadversae_2k";};
      description = ''
        Output name to wallpaper name. Names are the keys of the wallpaper set,
        the same values cnix.settings.theme.background takes. Entries resolving
        to null are skipped. Output names come from `wlr-randr`.
      '';
    };

    mode = mkOption {
      type = types.enum ["stretch" "fill" "fit" "center" "tile" "solid_color"];
      default = "fill";
      description = "swaybg scaling mode, applied to every output.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = wanted != {};
        message = "cnix.services.swaybg: no output has a wallpaper.";
      }
    ];

    systemd.user.services.swaybg = {
      description = "swaybg wallpaper";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/swaybg ${args}";
        Restart = "always";
        RestartSec = 1;
        Slice = "session.slice";
      };
    };

    environment.systemPackages = [cfg.package];
  };
}
