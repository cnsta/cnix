{
  config,
  lib,
  pkgs,
  ...
}:
let
  unit = "jellyfin";
  cfg = config.server.services.${unit};
  srv = config.server;
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
