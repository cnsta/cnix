let
  cnst = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIk/zMuOgZCX+bVCFDHxtoec96RaVfV4iG1Gohp0qHdU cnst@cnix";

  cnix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFfRlSRg6vV0rRokzzDWnGZgSaUo0SZaURbxxeYXfm6e root@nixos";
in {
  "cnstssh.age".publicKeys = [cnst cnix];
  "cnixssh.age".publicKeys = [cnst cnix];
  "lock.jpg".publicKeys = [cnst cnix];
}
