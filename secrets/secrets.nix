let
  # --- Users ---
  ukima = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUub8vbzUn2f39ILhAJ2QeH8xxLSjiyUuo8xvHGx/VB adam@cnst.dev";
  rkima = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJjoPdpiF8pjKN3ZEHeLEwVxoqwcCdzpVVlZkxJohFdg root@cnix";

  # --- Hosts: bunk ---
  ubunk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXCjkKouZrsMoswMIeueO8X/c3kuY3Gb0E9emvkqwUv cnst@cnixpad";
  rbunk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH72llEVDSHH/FZnjLVCe6zfdkdJRRVg2QL+ifHiPXXk root@cnix";

  # --- Hosts: sobotka ---
  usobotka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5ydTeaWcowmNXdDNqIa/lb5l9w5CAzyF2Kg6U5PSSu cnst@sobotka";
  rsobotka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWLTYWowtpGmGolmkCE7+l9jr5QEnDqRxoezNqAIe+j root@nixos";

  # --- Hosts: ziggy ---
  uziggy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtL8uBsJ3UL4+scqjEcyXYQOVlKziJk9YJ78YP6jCxq cnst@nixos";
  rziggy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHnca8xg1MZ4Hx5k5SVFSxcPnWc1O6r7w7JGYzX9aQm8 root@nixos";

  # --- Groups ---
  kima = [
    ukima
    rkima
  ];
  bunk = [
    ubunk
    rbunk
  ];
  sobotka = [
    usobotka
    rsobotka
  ];
  ziggy = [
    uziggy
    rziggy
  ];
  all = kima ++ bunk ++ sobotka ++ ziggy;
in
{
  # Generic
  "cnstssh.age".publicKeys = kima;
  "cnixssh.age".publicKeys = kima;
  "certpem.age".publicKeys = kima;
  "keypem.age".publicKeys = kima;
  "mailpwd.age".publicKeys = kima;
  "gcapi.age".publicKeys = kima;

  # Shared between kima + sobotka
  "cloudflareEnvironment.age".publicKeys = kima ++ sobotka;
  "vaultwardenEnvironment.age".publicKeys = kima ++ sobotka;
  "homepageEnvironment.age".publicKeys = kima ++ sobotka;
  "cloudflareFirewallApiKey.age".publicKeys = kima ++ sobotka;
  "vaultwardenCloudflared.age".publicKeys = kima ++ sobotka;
  "nextcloudCloudflared.age".publicKeys = kima ++ sobotka;
  "nextcloudAdminPass.age".publicKeys = kima ++ sobotka;
  "cloudflareDnsApiToken.age".publicKeys = kima ++ sobotka;
  "cloudflareDnsCredentials.age".publicKeys = kima ++ sobotka;
  "wgCredentials.age".publicKeys = kima ++ sobotka;
  "wgSobotkaPrivateKey.age".publicKeys = kima ++ sobotka;
  "gluetunEnvironment.age".publicKeys = kima ++ sobotka;
  "sobotkaPihole.age".publicKeys = kima ++ sobotka;
  "slskd.age".publicKeys = kima ++ sobotka;
  "authentikEnv.age".publicKeys = kima ++ sobotka;
  "traefikEnv.age".publicKeys = kima ++ sobotka;

  # Ziggy-specific
  "cloudflareDnsCredentialsZiggy.age".publicKeys = kima ++ ziggy;
  "ziggyPihole.age".publicKeys = kima ++ ziggy;

  # Both sobotka + ziggy (for HA stuff like keepalived)
  "keepalived.age".publicKeys = kima ++ sobotka ++ ziggy;
}
