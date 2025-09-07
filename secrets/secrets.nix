let
  cnst = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUub8vbzUn2f39ILhAJ2QeH8xxLSjiyUuo8xvHGx/VB adam@cnst.dev";
  kima = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJjoPdpiF8pjKN3ZEHeLEwVxoqwcCdzpVVlZkxJohFdg root@cnix";
  usobotka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5ydTeaWcowmNXdDNqIa/lb5l9w5CAzyF2Kg6U5PSSu cnst@sobotka";
  rsobotka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWLTYWowtpGmGolmkCE7+l9jr5QEnDqRxoezNqAIe+j root@nixos";
  uziggy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtL8uBsJ3UL4+scqjEcyXYQOVlKziJk9YJ78YP6jCxq cnst@nixos";
  rziggy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHnca8xg1MZ4Hx5k5SVFSxcPnWc1O6r7w7JGYzX9aQm8 root@nixos";
in
{
  "cnstssh.age".publicKeys = [
    cnst
    kima
  ];
  "cnixssh.age".publicKeys = [
    cnst
    kima
  ];
  "certpem.age".publicKeys = [
    cnst
    kima
  ];
  "keypem.age".publicKeys = [
    cnst
    kima
  ];
  "mailpwd.age".publicKeys = [
    cnst
    kima
  ];
  "gcapi.age".publicKeys = [
    cnst
    kima
  ];
  "cloudflareEnvironment.age".publicKeys = [
    cnst
    kima
    usobotka
    rsobotka
  ];
  "vaultwardenEnvironment.age".publicKeys = [
    cnst
    kima
    usobotka
    rsobotka
  ];
  "homepageEnvironment.age".publicKeys = [
    cnst
    kima
    usobotka
    rsobotka
  ];
  "cloudflareFirewallApiKey.age".publicKeys = [
    cnst
    kima
    usobotka
    rsobotka
  ];
  "vaultwardenCloudflared.age".publicKeys = [
    cnst
    kima
    usobotka
    rsobotka
  ];
  "cloudflareDnsApiToken.age".publicKeys = [
    cnst
    kima
    usobotka
    rsobotka
  ];
  "cloudflareDnsCredentials.age".publicKeys = [
    cnst
    kima
    usobotka
    rsobotka
    uziggy
    rziggy
  ];
  "wgCredentials.age".publicKeys = [
    cnst
    kima
    usobotka
    rsobotka
  ];
  "wgSobotkaPrivateKey.age".publicKeys = [
    cnst
    kima
    usobotka
    rsobotka
  ];
  "gluetunEnvironment.age".publicKeys = [
    cnst
    kima
    usobotka
    rsobotka
  ];
  "pihole.age".publicKeys = [
    cnst
    kima
    usobotka
    rsobotka
    uziggy
    rziggy
  ];
  "slskd.age".publicKeys = [
    cnst
    kima
    usobotka
    rsobotka
  ];
}
