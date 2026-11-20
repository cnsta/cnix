{
  lib,
  pkgs,
  ...
}: let
  modprobe = "${pkgs.kmod}/bin/modprobe";
in {
  imports = [
    ./hardware-configuration.nix
    ./settings.nix
  ];

  # The MT7922 (mt7921e) fails pci_pm_resume with -110 on every S3 wake and comes
  # back half-dead (associated but no traffic). Unload it before sleep, load it fresh on resume.
  powerManagement.powerDownCommands = ''
    ${modprobe} -r mt7921e || true
  '';

  powerManagement.resumeCommands = ''
    ${modprobe} mt7921e || true

    # Fix for weird touchpad quirk. Sometimes on wake the touchpad applies a "ghost finger", this unbind/bind command solves this.
    d=/sys/bus/i2c/drivers/i2c_hid_acpi
    if [ -e $d/i2c-GXTP5140:00 ]; then
      echo -n i2c-GXTP5140:00 > $d/unbind
      sleep 0.5
      echo -n i2c-GXTP5140:00 > $d/bind
    fi
  '';

  system.stateVersion = lib.mkDefault "26.05";
}
