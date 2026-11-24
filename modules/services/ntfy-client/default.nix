{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.cnix.services.ntfy-client;
  acct = config.cnix.settings.accounts;
in {
  options.cnix.services.ntfy-client = {
    enable = mkEnableOption "desktop notifications from an ntfy topic";
    url = mkOption {
      type = types.str;
      default = "https://ntfy.${config.cnix.settings.site.domains.public}";
      defaultText = lib.literalExpression ''"https://ntfy.''${config.cnix.settings.site.domains.public}"'';
      description = "ntfy server URL.";
    };
    topic = mkOption {
      type = types.str;
      default = "miniflux";
      description = "Topic to subscribe to.";
    };
  };

  config = mkIf cfg.enable {
    age.secrets.ntfyClientToken = {
      file = self + "/secrets/ntfyClientToken.age";
      owner = acct.username;
      mode = "0400";
    };

    systemd.user.services.ntfy-subscribe = {
      description = "ntfy ${cfg.topic} → desktop notifications";
      after = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      path = [pkgs.libnotify];
      serviceConfig = {
        EnvironmentFile = config.age.secrets.ntfyClientToken.path;
        ExecStart = "${lib.getExe' pkgs.ntfy-sh "ntfy"} subscribe ${cfg.url}/${cfg.topic} ${lib.escapeShellArg ''notify-send -a ${cfg.topic} "$t" "$m"''}";
        Restart = "always";
        RestartSec = "10";
      };
    };
  };
}
