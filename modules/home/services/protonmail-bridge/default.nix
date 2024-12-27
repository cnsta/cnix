{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption optionalString;
  cfg = config.home.services.protonmail-bridge;
in {
  options = {
    home.services.protonmail-bridge.enable = mkEnableOption "Enables protonmail-bridge";
  };
  config = mkIf cfg.enable {
    home.packages = [pkgs.protonmail-bridge];
    systemd.user.services.protonmail-bridge = {
      Unit = {
        Description = "Protonmail Bridge";
        After = ["network.target"];
      };

      Service = {
        Restart = "always";
        ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --no-window --noninteractive";
      };

      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
