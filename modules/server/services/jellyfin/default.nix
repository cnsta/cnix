{
  config,
  lib,
  pkgs,
  ...
}:
let
  unit = "jellyfin";
  cfg = config.cnix.server.services.${unit};
  srv = config.cnix.server;
in
{
  config = lib.mkIf cfg.enable {
    services.${unit} = {
      enable = true;
      user = srv.user;
      group = srv.group;
    };
    environment.systemPackages = with pkgs; [
      jellyfin-ffmpeg
    ];
  };
}
