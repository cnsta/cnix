{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.virtualisation;
in
{
  options = {
    nixos.services.virtualisation.enable = mkEnableOption "Enables virtualisation";
  };
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
    nixos.services.virtualisation.vfio.enable = true;
  };
}
