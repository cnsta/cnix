{
  lib,
  srv,
  ...
}:
lib.optionals srv.services.pihole.enable [
  {
    type = "dns-stats";
    service = "pihole-v6";
    url = "http://127.0.0.1:${toString srv.services.pihole.port}";
    password = "\${PIHOLE_PASSWORD}";
    "hour-format" = "24h";
  }
]
