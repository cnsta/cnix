{lib, ...}: let
  enable = true;
in
  lib.optional enable {
    type = "custom-api";
    title = "Gluetun status";
    cache = "1m";
    url = "http://\${GLUETUN_URL}/v1/publicip/ip";
    headers."X-API-Key" = "\${GLUETUN_API_KEY}";
    template = builtins.readFile ./templates/gluetun.html;
  }
