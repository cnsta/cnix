let
  # --- Users ---
  ukima = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmCpN9bDtv7Wr4MYn3zf10yivAENDynFTq0y3M+c85X cnst@kima";
  rkima = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHUx5j5tTgRMmLB/DC1nmRdPeNZC04UQiF3aDowhd+kn root@nixos";

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
in {
  "accessTokens.age".publicKeys = all;

  # Generic
  # "cnstssh.age".publicKeys = kima;
  # "cnixssh.age".publicKeys = kima;
  # "certpem.age".publicKeys = kima;
  # "keypem.age".publicKeys = kima;
  # "mailpwd.age".publicKeys = kima;
  # "gcapi.age".publicKeys = kima;

  # Shared between kima + sobotka
  "cloudflareEnvironment.age".publicKeys = sobotka;
  "vaultwardenEnvironment.age".publicKeys = sobotka;
  "homepageEnvironment.age".publicKeys = sobotka;
  "cloudflareFirewallApiKey.age".publicKeys = sobotka;
  "vaultwardenCloudflared.age".publicKeys = sobotka;
  "giteaCloudflared.age".publicKeys = sobotka;
  "nextcloudCloudflared.age".publicKeys = sobotka;
  "nextcloudAdminPass.age".publicKeys = sobotka;
  "cloudflareDnsApiToken.age".publicKeys = sobotka;
  "cloudflareDnsCredentials.age".publicKeys = sobotka;
  "wgCredentials.age".publicKeys = sobotka;
  "wgSobotkaPrivateKey.age".publicKeys = sobotka;
  "gluetunEnvironment.age".publicKeys = sobotka;
  "sobotkaPihole.age".publicKeys = sobotka;
  "slskd.age".publicKeys = sobotka;
  "authentikEnv.age".publicKeys = sobotka;
  "traefikEnv.age".publicKeys = sobotka;
  "wwwCloudflared.age".publicKeys = sobotka;
  "authentikCloudflared.age".publicKeys = sobotka;
  "sobotkaTsAuth.age".publicKeys = sobotka;
  "forgejoCloudflared.age".publicKeys = sobotka;

  # Ziggy-specific
  "cloudflareDnsCredentialsZiggy.age".publicKeys = ziggy;
  "ziggyPihole.age".publicKeys = ziggy;

  # Both sobotka + ziggy (for HA stuff like keepalived)
  "keepalived.age".publicKeys = sobotka ++ ziggy;
}
