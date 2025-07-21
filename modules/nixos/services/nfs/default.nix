{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.nixos.services.nfs;
in {
  options.nixos.services.nfs = {
    enable = mkEnableOption "Enable NFS support";

    server = {
      enable = mkEnableOption "Enable the NFS server";
      exports = mkOption {
        type = types.str;
        default = "/shared *(rw,async,wdelay,root_squash,no_subtree_check)";
        description = "NFS export entries";
      };
    };

    client = {
      enable = mkEnableOption "Enable NFS client mounting";
      mountPoint = mkOption {
        type = types.str;
        default = "/shared";
        description = "Mount point for NFS share";
      };
      device = mkOption {
        type = types.str;
        default = "sobotka:/shared";
        description = "Remote NFS device";
      };
      fsType = mkOption {
        type = types.str;
        default = "nfs4";
        description = "Filesystem type";
      };
      options = mkOption {
        type = types.listOf types.str;
        default = ["x-systemd.automount"];
        description = "Mount options";
      };
    };
  };

  config = mkIf cfg.enable {
    boot.supportedFilesystems = ["nfs"];
    services.rpcbind.enable = true;
    networking.firewall = {
      allowedTCPPorts = [2049 4000 4001 4002];
      allowedUDPPorts = [2049 4000 4001 4002];
    };

    services.nfs.server = mkIf cfg.server.enable {
      enable = true;
      exports = cfg.server.exports;
    };

    fileSystems = mkIf cfg.client.enable {
      "${cfg.client.mountPoint}" = {
        device = cfg.client.device;
        fsType = cfg.client.fsType;
        options = cfg.client.options;
      };
    };
  };
}
