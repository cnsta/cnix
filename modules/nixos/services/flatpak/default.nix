{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.flatpak;
in {
  options = {
    nixos.services.flatpak.enable = mkEnableOption "Enables flatpaks and gnome software";
  };
  config = mkIf cfg.enable {
    services.flatpak.enable = true;
    environment.systemPackages = with pkgs; [
      gnome-software
    ];
    systemd.services.flatpak-repo = {
      wantedBy = ["multi-user.target"];
      requires = ["network-online.target"];
      after = ["network-online.target"];
      path = [pkgs.flatpak];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
  };
}
