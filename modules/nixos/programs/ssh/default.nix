{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.openssh;
in
{
  options = {
    nixos.services.openssh = {
      enable = mkEnableOption "Enables ssh";
    };
  };
  config = mkIf cfg.enable {
    programs.ssh = {
      knownHosts = {
        publicKeyFile = /etc/ssh/ssh_host_ed25519_key.pub;
      };
    };
    services.openssh = {
      enable = true;
      settings = {
        AcceptEnv = "WAYLAND_DISPLAY";
        GatewayPorts = "clientspecified";
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        X11Forwarding = true;
      };
    };
  };
}
