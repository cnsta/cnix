{
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./settings.nix
  ];

  networking = {
    hostName = "kima";
  };

  # Remove when 'finished' with lightcrazy dev work
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
