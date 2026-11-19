{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./settings.nix
  ];

  # Fix for weird touchpad quirk. Sometimes on wake the touchpad applies a "ghost finger", this unbind/bind command solves this.
  powerManagement.resumeCommands = ''
    d=/sys/bus/i2c/drivers/i2c_hid_acpi
    if [ -e $d/i2c-GXTP5140:00 ]; then
      echo -n i2c-GXTP5140:00 > $d/unbind
      sleep 0.5
      echo -n i2c-GXTP5140:00 > $d/bind
    fi
  '';

  system.stateVersion = lib.mkDefault "26.05";
}
