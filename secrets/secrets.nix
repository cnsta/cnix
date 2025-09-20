let
  # --- Users ---
  cnst = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUub8vbzUn2f39ILhAJ2QeH8xxLSjiyUuo8xvHGx/VB adam@cnst.dev";
  kima = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJjoPdpiF8pjKN3ZEHeLEwVxoqwcCdzpVVlZkxJohFdg root@cnix";

  # --- Hosts: sobotka ---
  usobotka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5ydTeaWcowmNXdDNqIa/lb5l9w5CAzyF2Kg6U5PSSu cnst@sobotka";
  rsobotka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWLTYWowtpGmGolmkCE7+l9jr5QEnDqRxoezNqAIe+j root@nixos";

  # --- Hosts: ziggy ---
  uziggy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtL8uBsJ3UL4+scqjEcyXYQOVlKziJk9YJ78YP6jCxq cnst@nixos";
  rziggy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHnca8xg1MZ4Hx5k5SVFSxcPnWc1O6r7w7JGYzX9aQm8 root@nixos";

  # --- Groups ---
  core = [
    cnst
    kima
  ];
  sobotka = [
    usobotka
    rsobotka
  ];
  ziggy = [
    uziggy
    rziggy
  ];
  all = core ++ sobotka ++ ziggy;
in {
  # Generic
  "cnstssh.age".publicKeys = core;
  "cnixssh.age".publicKeys = core;
  "certpem.age".publicKeys = core;
  "keypem.age".publicKeys = core;
  "mailpwd.age".publicKeys = core;
  "gcapi.age".publicKeys = core;

  # Shared between core + sobotka
  "cloudflareEnvironment.age".publicKeys = core ++ sobotka;
  "vaultwardenEnvironment.age".publicKeys = core ++ sobotka;
  "homepageEnvironment.age".publicKeys = core ++ sobotka;
  "cloudflareFirewallApiKey.age".publicKeys = core ++ sobotka;
  "vaultwardenCloudflared.age".publicKeys = core ++ sobotka;
  "keycloakDbPasswordFile.age".publicKeys = core ++ sobotka;
  "keycloakCloudflared.age".publicKeys = core ++ sobotka;
  "nextcloudCloudflared.age".publicKeys = core ++ sobotka;
  "nextcloudAdminPass.age".publicKeys = core ++ sobotka;
  "cloudflareDnsApiToken.age".publicKeys = core ++ sobotka;
  "cloudflareDnsCredentials.age".publicKeys = core ++ sobotka;
  "wgCredentials.age".publicKeys = core ++ sobotka;
  "wgSobotkaPrivateKey.age".publicKeys = core ++ sobotka;
  "gluetunEnvironment.age".publicKeys = core ++ sobotka;
  "pihole.age".publicKeys = core ++ sobotka;
  "slskd.age".publicKeys = core ++ sobotka;

  # Ziggy-specific
  "cloudflareDnsCredentialsZiggy.age".publicKeys = core ++ ziggy;
  "piholeZiggy.age".publicKeys = core ++ ziggy;

  # Both sobotka + ziggy (for HA stuff like keepalived)
  "keepalived.age".publicKeys = core ++ sobotka ++ ziggy;
}
