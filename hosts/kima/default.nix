{
  lib,
  config,
  pkgs,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users.cnst = {
    isNormalUser = true;
    shell = pkgs.nushell;
    extraGroups = ifTheyExist [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "git"
      "mysql"
      "docker"
      "libvirtd"
      "qemu-libvirtd"
      "kvm"
      "network"
      "gamemode"
      "adbusers"
      "users"
      "plocate"
      "fuse"
      "i2c"
      "wireshark"
    ];
  };

  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./settings.nix
  ];

  networking = {
    hostName = "kima";
  };

  environment.variables = {
    NH_FLAKE = "/home/cnst/.nix-config";
    GTK_THEME = "Adwaita:dark";
  };

  services.udev.extraRules = ''
    # Pulsar X2 CrazyLight (wired) - USB
    SUBSYSTEM=="usb", ATTRS{idVendor}=="3710", ATTRS{idProduct}=="3414", MODE="0666", TAG+="uaccess"
    # Pulsar 8K Dongle (wireless) - USB
    SUBSYSTEM=="usb", ATTRS{idVendor}=="3710", ATTRS{idProduct}=="5406", MODE="0666", TAG+="uaccess"

    # Pulsar X2 - hidraw (for non-blocking battery reading)
    KERNEL=="hidraw*", ATTRS{idVendor}=="3710", ATTRS{idProduct}=="3414", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="3710", ATTRS{idProduct}=="5406", MODE="0666", TAG+="uaccess"
  '';

  system.stateVersion = lib.mkDefault "25.11";
}
