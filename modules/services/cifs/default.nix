{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types mapAttrs;
  cfg = config.cnix.services.cifs;

  host = config.networking.hostName;
  secretName = "${host}SmbCredentials";

  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
in {
  options.cnix.services.cifs = {
    enable = mkEnableOption "Enables cifs/smb network share mounts";

    shares = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          device = mkOption {
            type = types.str;
            example = "//192.168.88.223/libellux";
            description = "Remote share to mount.";
          };
          extraOptions = mkOption {
            type = types.listOf types.str;
            default = [];
            example = ["uid=1000" "gid=100"];
            description = "Extra mount options appended after the defaults.";
          };
        };
      });
      default = {};
      description = "CIFS shares, keyed by mount point.";
    };
  };

  config = mkIf cfg.enable {
    age.secrets.${secretName} = {
      file = self + "/secrets/${secretName}.age";
    };

    environment.systemPackages = [pkgs.cifs-utils];

    fileSystems =
      mapAttrs (mountPoint: share: {
        inherit (share) device;
        fsType = "cifs";
        options =
          ["${automount_opts},credentials=${config.age.secrets.${secretName}.path}"]
          ++ share.extraOptions;
      })
      cfg.shares;
  };
}
