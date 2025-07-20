let
  cnst = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUub8vbzUn2f39ILhAJ2QeH8xxLSjiyUuo8xvHGx/VB adam@cnst.dev";
  kima = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJjoPdpiF8pjKN3ZEHeLEwVxoqwcCdzpVVlZkxJohFdg root@cnix";
  usobotka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5ydTeaWcowmNXdDNqIa/lb5l9w5CAzyF2Kg6U5PSSu cnst@sobotka";
  rsobotka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWLTYWowtpGmGolmkCE7+l9jr5QEnDqRxoezNqAIe+j root@nixos";
in {
  "cnstssh.age".publicKeys = [cnst kima];
  "cnixssh.age".publicKeys = [cnst kima];
  "certpem.age".publicKeys = [cnst kima];
  "keypem.age".publicKeys = [cnst kima];
  "mailpwd.age".publicKeys = [cnst kima];
  "gcapi.age".publicKeys = [cnst kima];
  "cloudflare-env.age".publicKeys = [cnst kima usobotka rsobotka];
  "vaultwarden-env.age".publicKeys = [cnst kima usobotka rsobotka];
  "homepage-env.age".publicKeys = [cnst kima usobotka rsobotka];
  "cloudflareFirewallApiKey.age".publicKeys = [cnst kima usobotka rsobotka];
  "vaultwardenCloudflared.age".publicKeys = [cnst kima usobotka rsobotka];
  "cloudflareDnsApiToken.age".publicKeys = [cnst kima usobotka rsobotka];
  "cloudflareDnsCredentials.age".publicKeys = [cnst kima usobotka rsobotka];
  "wgCredentials.age".publicKeys = [cnst kima usobotka rsobotka];
  "wgSobotkaPrivateKey.age".publicKeys = [cnst kima usobotka rsobotka];
  "gluetunEnv.age".publicKeys = [cnst kima usobotka rsobotka];
}
