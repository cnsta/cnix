{ lib, config, ... }:
let
  gpuIDs = [
    "1002:13c0"
    "1002:1640"
  ];

  vfioIds = "vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs;
  baseBootKernelParams = config.boot.kernelParams or [ ];
  cfg = config.nixos.services.virtualisation.vfio;
in
{
  options = {
    nixos.services.virtualisation.vfio.enable =
      lib.mkEnableOption "Enable VFIO passthrough for the iGPU";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];

      kernelParams = [
        "amd_iommu=on"
        "iommu=pt"
      ]
      ++ [ vfioIds ];
    };

    specialisation.vfio.configuration = {
      system.nixos.tags = [ "vfio" ];
      boot = {
        kernelParams = baseBootKernelParams ++ [ vfioIds ];
        blacklistedKernelModules = [ "amdgpu:0f:00.0" ];
      };
    };
  };
}
