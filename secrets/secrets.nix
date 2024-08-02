let
  cnst = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJMWwiz9YWBMUKFtAmF3xTEdBW27zkBH8UYaqWWcs70d cnst@cnix";
in {
  "secret1.age".publicKeys = [cnst];
}
