let
  cnst = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUub8vbzUn2f39ILhAJ2QeH8xxLSjiyUuo8xvHGx/VB adam@cnst.dev";
  cnix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJjoPdpiF8pjKN3ZEHeLEwVxoqwcCdzpVVlZkxJohFdg root@cnix";
in {
  "cnstssh.age".publicKeys = [cnst cnix];
  "cnixssh.age".publicKeys = [cnst cnix];
  "certpem.age".publicKeys = [cnst cnix];
  "keypem.age".publicKeys = [cnst cnix];
  "mailpwd.age".publicKeys = [cnst cnix];
}
