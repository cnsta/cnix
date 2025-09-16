{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.libvirtd;
in
{
  options = {
    nixos.services.libvirtd.enable = mkEnableOption "Enables libvirtd";
  };

  config = mkIf cfg.enable {
    networking.firewall.trustedInterfaces = [ "virbr0" ];
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
    ];

    virtualisation = {
      kvmgt.enable = true;
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        onShutdown = "shutdown";
        qemu = {
          ovmf = {
            enable = true;
            packages = [ pkgs.OVMFFull.fd ];
          };
        };
      };
    };
  };
}
