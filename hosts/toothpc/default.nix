{
  lib,
  self,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./settings.nix
  ];

  age.secrets."smb-credentials" = {
    file = self + "/secrets/smb-credentials.age";
  };
  environment.systemPackages = [pkgs.cifs-utils];
  fileSystems."/mnt/share" = {
    device = "//192.168.88.223/libellux";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=${config.age.secrets.smb-credentials.path}"];
  };

  networking.hostName = "toothpc";

  time.hardwareClockInLocalTime = true;

  system.stateVersion = lib.mkDefault "25.11";
}
