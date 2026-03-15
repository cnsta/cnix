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
    nixos.services.ssh = {
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
        GatewayPorts = "clientspecified";
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        X11Forwarding = false;
        KbdInteractiveAuthentication = false;
        MaxAuthTries = 3;
        LoginGraceTime = 20;
        MaxStartups = "10:30:60";
        MaxSessions = 5;
        ClientAliveInterval = 300;
        ClientAliveCountMax = 2;
        LogLevel = "VERBOSE";
        HostKeyAlgorithms = lib.concatStringsSep "," [
          "ssh-ed25519"
          "ssh-ed25519-cert-v01@openssh.com"
          "rsa-sha2-512"
          "rsa-sha2-512-cert-v01@openssh.com"
          "rsa-sha2-256"
          "rsa-sha2-256-cert-v01@openssh.com"
        ];
      };
    };
  };
}
