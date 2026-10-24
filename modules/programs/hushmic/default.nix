{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.hushmic;
  hushmic = self.inputs.hushmic.packages.${pkgs.stdenv.hostPlatform.system}.hushmic;
in {
  options.cnix.programs.hushmic.enable = mkEnableOption "Enables hushmic";

  config = mkIf cfg.enable {
    environment.systemPackages = [
      hushmic
    ];

    systemd.user.services.hushmic = {
      description = "HushMic noise-suppression virtual microphone";
      documentation = ["https://github.com/Fovty/hushmic"];
      after = ["graphical-session.target" "pipewire.service" "wireplumber.service"];
      wants = ["pipewire.service"];
      partOf = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];

      serviceConfig = {
        ExecStart = "${lib.getExe hushmic} --tray";
        Restart = "on-failure";
        RestartSec = 3;
        KillMode = "mixed";
        TimeoutStopSec = 10;
        Slice = "session.slice";
      };
    };
  };
}
