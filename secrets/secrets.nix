let
  # --- Users ---
  ukima = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmCpN9bDtv7Wr4MYn3zf10yivAENDynFTq0y3M+c85X cnst@kima";
  rkima = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHUx5j5tTgRMmLB/DC1nmRdPeNZC04UQiF3aDowhd+kn root@nixos";

  # --- Hosts: bunk ---
  ubunk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHd48tFwqAKAoE+37zDsTGQTrBS/6cQ+kQQw3596XsdY cnst@bunk";
  rbunk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGwhIj0kRDt3WbpBPF/JbQsrLWIVGWjfz78p8L0ij16M root@bunk";

  # --- Hosts: sobotka ---
  usobotka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5ydTeaWcowmNXdDNqIa/lb5l9w5CAzyF2Kg6U5PSSu cnst@sobotka";
  rsobotka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWLTYWowtpGmGolmkCE7+l9jr5QEnDqRxoezNqAIe+j root@nixos";

  # --- Hosts: ziggy ---
  uziggy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtL8uBsJ3UL4+scqjEcyXYQOVlKziJk9YJ78YP6jCxq cnst@nixos";
  rziggy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHnca8xg1MZ4Hx5k5SVFSxcPnWc1O6r7w7JGYzX9aQm8 root@nixos";

  # --- Hosts: toothpc ---
  utoothpc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGe3s7WbaM0aZTYHCE1ugiG/SxFXLSbWcLAWceFotpuh toothpick@nixos";
  rtoothpc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzjuaOX94oRwWVsRjE4mo5QTw35lEmFKyHtlh2XCTBg root@toothpc";

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
  toothpc = [
    utoothpc
    rtoothpc
  ];

  all = kima ++ bunk ++ sobotka ++ ziggy ++ toothpc;
in
{
  # Sobotka-specific
  "cloudflareEnvironment.age".publicKeys = sobotka;
  "vaultwardenEnvironment.age".publicKeys = sobotka;
  "homepageEnvironment.age".publicKeys = sobotka;
  "cloudflareFirewallApiKey.age".publicKeys = sobotka;
  "vaultwardenCloudflared.age".publicKeys = sobotka;
  "nextcloudCloudflared.age".publicKeys = sobotka;
  "nextcloudAdminPass.age".publicKeys = sobotka;
  "cloudflareDnsApiToken.age".publicKeys = sobotka;
  "cloudflareDnsCredentials.age".publicKeys = sobotka;
  "wgCredentials.age".publicKeys = sobotka;
  "wgSobotkaPrivateKey.age".publicKeys = sobotka;
  "gluetunEnvironment.age".publicKeys = sobotka;
  "sobotkaPihole.age".publicKeys = sobotka;
  "slskd.age".publicKeys = sobotka;
  "traefikEnv.age".publicKeys = sobotka;
  "wwwCloudflared.age".publicKeys = sobotka;
  "authentikEnv.age".publicKeys = sobotka;
  "authentikCloudflared.age".publicKeys = sobotka;
  "sobotkaTsAuth.age".publicKeys = sobotka;
  "matrixShared.age".publicKeys = sobotka;

  # Ziggy-specific
  "cloudflareDnsCredentialsZiggy.age".publicKeys = ziggy;
  "ziggyPihole.age".publicKeys = ziggy;

  # Both sobotka + ziggy (for HA stuff like keepalived)
  "keepalived.age".publicKeys = sobotka ++ ziggy;
}
