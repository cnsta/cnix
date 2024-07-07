{pkgs, ...}: {
  imports = [
    ./pipewire.nix
    ./greetd.nix
    ./xserver.nix
    ./openssh.nix
    ./mullvad.nix
  ];
}
