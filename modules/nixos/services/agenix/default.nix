{
  config,
  lib,
  inputs,
  pkgs,
  self,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.agenix;
  host = config.networking.hostName;

  perHost = {
    kima = {
    };
    bunk = {
    };
    sobotka = {
      cloudflareFirewallApiKey.file = (self + "/secrets/cloudflareFirewallApiKey.age");
      cloudflareDnsApiToken.file = (self + "$/secrets/cloudflareDnsApiToken.age");
      cloudflareDnsCredentials.file = (self + "/secrets/cloudflareDnsCredentials.age");
      wgCredentials.file = (self + "/secrets/wgCredentials.age");
      wgSobotkaPrivateKey.file = (self + "/secrets/wgSobotkaPrivateKey.age");
    };
    ziggy = {
      cloudflareDnsCredentialsZiggy.file = (self + "/secrets/cloudflareDnsCredentialsZiggy.age");
    };
    toothpc = {
    };
  };
in
{
  imports = [ inputs.agenix.nixosModules.default ];

  options.nixos.services.agenix.enable = mkEnableOption "agenix system environment";

  config = mkIf cfg.enable {
    age.secrets = perHost.${host} or (throw "agenix: no secrets bundle defined for host '${host}'");

    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.age
    ];
  };
}
