{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.server = {
    email = mkOption {
      default = "";
      type = types.str;
      description = ''
        Email name to be used to access the server services via Caddy reverse proxy
      '';
    };
    domain = mkOption {
      default = "";
      type = types.str;
      description = ''
        Domain name to be used to access the server services via Caddy reverse proxy
      '';
    };
  };
}
