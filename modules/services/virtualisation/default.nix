{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.services.virtualisation;
in
{
  options.cnix.services.virtualisation.enable = mkEnableOption "Enables virtualisation";

  imports = [
    ./vfio.nix
  ];

  config = mkIf cfg.enable {
    networking.firewall.trustedInterfaces = [ "virbr0" ];
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
    ];

    virtualisation = {
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
    cnix.services.virtualisation.vfio.enable = true;
  };
}
