{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    getExe
    escapeShellArg
    filterAttrs
    attrNames
    optionalAttrs
    concatStringsSep
    length
    head
    ;

  cfg = config.cnix.services.greetd;
  hyprcfg = config.cnix.programs.hyprland;
  niricfg = config.cnix.programs.niri;
  rivercfg = config.cnix.programs.river;
  riverDeltacfg = config.cnix.programs.river-delta;
  username = config.cnix.settings.accounts.username;

  compositors = {
    hyprland = {
      enable = hyprcfg.enable;
      command = "${getExe config.programs.uwsm.package} start hyprland.desktop";
    };
    niri = {
      enable = niricfg.enable;
      command = "${config.programs.niri.package}/bin/niri-session";
    };
    river = {
      enable = rivercfg.enable;
      command = "${config.programs.river-rhine.sessionScript}";
    };
    river-delta = {
      enable = riverDeltacfg.enable;
      command = "${config.programs.river-delta.sessionScript}";
    };
  };

  enabled = filterAttrs (_: c: c.enable) compositors;
  names = attrNames enabled;
  selected =
    if names == []
    then null
    else enabled.${head names};

  selectedCommand =
    if selected == null
    then "true"
    else selected.command;

  sessionDirs = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";

  tuigreetArgs =
    ["--time" "--remember"]
    ++ (
      if cfg.sessionMenu
      then [
        "--sessions"
        sessionDirs
        "--remember-session"
      ]
      else ["--cmd" (escapeShellArg selectedCommand)]
    );

  greeter = "${getExe pkgs.tuigreet} ${concatStringsSep " " tuigreetArgs}";

  autoLogin = cfg.autoLogin && !cfg.sessionMenu && selected != null;
in {
  options.cnix.services.greetd = {
    enable = mkEnableOption "greetd display manager";

    sessionMenu = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Offer every registered Wayland session in tuigreet instead of launching
        a single hardcoded compositor. Lifts the one-compositor-per-host
        restriction, at the cost of a session picker on every login.
      '';
    };

    autoLogin = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Log the configured user straight into the selected compositor with no
        greeter, via greetd's initial_session.

        Ignored when sessionMenu is set: a picker and an autologin are mutually
        exclusive by definition.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.greetd.enable;
        message = "cnix.services.greetd is enabled but services.greetd.enable was not set.";
      }
      {
        assertion = cfg.sessionMenu || length names <= 1;
        message = ''
          cnix.services.greetd: ${toString (length names)} compositors are
          enabled (${concatStringsSep ", " names}) and each would define
          services.greetd.settings.default_session.command, which is a plain
          string option that cannot merge.

          Either enable one compositor, or set
          cnix.services.greetd.sessionMenu = true to pick between them at
          the greeter.
        '';
      }
      {
        assertion = cfg.sessionMenu || selected != null;
        message = ''
          cnix.services.greetd: greetd is enabled but no compositor is, so
          there is nothing to launch. Enable one of
          ${concatStringsSep ", " (attrNames compositors)}, or set sessionMenu.
        '';
      }
    ];

    services.greetd = {
      enable = true;
      restart = !autoLogin;
      settings =
        {
          terminal.vt = 1;
          default_session = {
            command = greeter;
            user = "greeter";
          };
        }
        // optionalAttrs autoLogin {
          initial_session = {
            command = selectedCommand;
            user = username;
          };
        };
    };

    systemd.tmpfiles.rules = [
      "d /var/cache/tuigreet 0755 greeter greeter - -"
    ];
  };
}
