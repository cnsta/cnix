{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) concatStringsSep genAttrs getExe getExe' mkEnableOption mkIf optionalString optionals;

  cfg = config.cnix.services.swayidle;
  acct = config.cnix.settings.accounts;

  swayidle = getExe pkgs.swayidle;
  lock = getExe pkgs.waylock;
  wlopm = getExe pkgs.wlopm;
  pgrep = getExe' pkgs.procps "pgrep";
  sleep = getExe' pkgs.coreutils "sleep";
  wpctl = getExe' pkgs.wireplumber "wpctl";

  lockTime = 300;
  lockCmd = "${sleep} 1 && ${lock} --daemonize --color 000000";

  isLocked = "${pgrep} -x swaylock >/dev/null 2>&1";

  afterLock = {
    timeout,
    command,
    resumeCommand ? null,
  }: [
    {
      timeout = lockTime + timeout;
      inherit command resumeCommand;
    }
    {
      command = "${isLocked} && ${command}";
      inherit timeout resumeCommand;
    }
  ];

  timeouts =
    [
      {
        timeout = lockTime;
        command = lockCmd;
      }
    ]
    ++ (afterLock {
      timeout = 10;
      command = "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ 1";
      resumeCommand = "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ 0";
    })
    ++ (optionals config.cnix.programs.river.enable (afterLock {
      timeout = 20;
      command = "${wlopm} --off \\*";
      resumeCommand = "${wlopm} --on \\*";
    }));

  mkTimeout = {
    timeout,
    command,
    resumeCommand ? null,
  }:
    "timeout ${toString timeout} '${command}'"
    + optionalString (resumeCommand != null) " resume '${resumeCommand}'";

  configFile =
    concatStringsSep "\n" (
      (map mkTimeout timeouts)
      ++ ["before-sleep '${lockCmd}'"]
    )
    + "\n";
in {
  options.cnix.services.swayidle.enable =
    mkEnableOption "swayidle, the idle management daemon for Wayland";

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.waylock];
    security.pam.services.waylock = {};
    systemd.user.services.swayidle = {
      description = "Idle manager for Wayland";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${swayidle} -w";
        Restart = "always";
        RestartSec = 1;
        Slice = "session.slice";
      };
    };

    hjem.users = genAttrs acct.defaultUsers (_: {
      files.".config/swayidle/config" = {
        text = configFile;
        clobber = true;
      };
    });
  };
}
