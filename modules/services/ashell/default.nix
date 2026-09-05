{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.cnix.services.ashell;
in {
  options.cnix.services.ashell = {
    enable = mkEnableOption "Enables ashell as a service";
    delta = {
      enable =
        mkEnableOption ''
          the delta compositor backend.
        ''
        // {default = true;};
    };

    package = mkOption {
      type = types.package;
      default =
        if cfg.delta.enable
        then inputs.river-delta.lib.withDelta inputs.ashell.packages.${pkgs.stdenv.hostPlatform.system}.default
        else inputs.ashell.packages.${pkgs.stdenv.hostPlatform.system}.default;
      defaultText = lib.literalMD "`pkgs.ashell`, patched when `delta.enable`";
      description = "The ashell package to run.";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.ashell = {
      description = "ashell status bar";
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        Restart = "always";
        RestartSec = 0;
        Slice = "session.slice";
      };
      unitConfig.StartLimitIntervalSec = 0;
    };
  };
}
