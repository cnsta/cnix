{
  config,
  lib,
  pkgs,
  bgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types escapeShellArgs concatMap attrNames filterAttrs filter listToAttrs;

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
      default = listToAttrs (map (m: {
        inherit (m) name;
        value = bg.${m.wallpaper};
      }) (filter (m: m.enable && m.wallpaper != null) config.cnix.settings.monitors));
      defaultText = lib.literalMD "each enabled monitor's `wallpaper` from cnix.settings.monitors";
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
        Type = "simple";
        ExecStart = "${cfg.package}/bin/swaybg ${args}";
        Restart = "on-failure";
        RestartSec = 0;
      };
    };

    environment.systemPackages = [cfg.package];
  };
}
