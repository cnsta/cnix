{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types escapeShellArgs;
  cfg = config.cnix.programs.niri;
  autostack = config.cnix.scripts.niri-autostack;

  autostackExec = pkgs.writeShellScript "niri-autostack-start" ''
    exec ${autostack.package}/bin/niri-autostack.sh ${escapeShellArgs cfg.autostack}
  '';
in {
  options.cnix.programs.niri = {
    enable = mkEnableOption "Enables niri";

    autostack = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["^foot$:2" "^org\\.wezfurlong\\.wezterm$:3"];
      description = ''
        Auto-stacking rules, each `APP_ID_REGEX:MAX_WINDOWS_PER_COLUMN`.
        A new window matching a rule is consumed into the column to its left
        when that column holds only windows matching the same rule and has
        fewer than MAX in it.

        Requires `cnix.scripts.niri-autostack.enable`. Leave empty to install
        the script without running the daemon.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";

      systemPackages = with pkgs; [
        xwayland-satellite
        wl-clipboard
        wayland-utils
      ];
    };

    systemd.user.services.niri-flake-polkit.enable = false;

    systemd.user.services.niri-autostack = mkIf (cfg.autostack != [] && autostack.enable) {
      description = "Auto-stack niri windows into columns";
      bindsTo = ["niri.service"];
      after = ["niri.service"];
      wantedBy = ["niri.service"];
      serviceConfig = {
        Type = "simple";
        ExecStart = autostackExec;
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    programs.niri.enable = true;
  };
}
