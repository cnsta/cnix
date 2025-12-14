{
  config,
  outputs,
  lib,
  self,
  ...
}:
let
  hosts = lib.attrNames outputs.nixosConfigurations;
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.ssh;

  hostsWithKeys = builtins.filter (
    hostname: builtins.pathExists "${self}/hosts/${hostname}/ssh_host_ed25519_key.pub"
  ) hosts;
in
{
  options = {
    nixos.services.openssh = {
      enable = mkEnableOption "Enables openssh";
    };
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      knownHosts = lib.genAttrs hostsWithKeys (hostname: {
        publicKeyFile = "${self}/hosts/${hostname}/ssh_host_ed25519_key.pub";
      });
    };

    services.openssh = {
      enable = true;
      settings = {
        AcceptEnv = "GIT_PROTOCOL";
        GatewayPorts = "clientspecified";
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        X11Forwarding = true;
      };
    };
  };
}
