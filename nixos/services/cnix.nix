{pkgs, ...}: {
  imports = [
    ./pipewire.nix
    ./greetd.nix
    ./xserver.nix
    ./openssh.nix
    ./mullvad.nix
  ];
  services = {
    dbus.packages = with pkgs; [
      gcr
    ];
    udisks2.enable = true;
    gvfs.enable = true;
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
  };
}
