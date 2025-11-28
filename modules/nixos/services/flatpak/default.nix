{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.flatpak;
in
{
  options = {
    nixos.services.flatpak.enable = mkEnableOption "Enables flatpaks and gnome software";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.bazaar ];
    services.flatpak.enable = true;
    systemd.services.flatpak-repo = {
      description = "Add flathub repository";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      path = [ pkgs.flatpak ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
