# kernel.nix
{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption;
  cfg = config.modules.boot.kernel;
in {
  options = {
    modules.boot.kernel = {
      variant = mkOption {
        type = lib.types.enum ["latest" "cachyos"];
        default = "latest";
        description = "Kernel variant to use.";
      };

      hardware = mkOption {
        type = lib.types.enum ["amd" "nvidia"];
        default = "amd";
        description = "Hardware type (GPU) configuration.";
      };

      extraKernelParams = mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Additional kernel parameters.";
      };

      extraBlacklistedModules = mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Additional kernel modules to blacklist.";
      };
    };
  };

  config = {
    boot = {
      consoleLogLevel = 3;

      kernelPackages = (
        if cfg.variant == "latest"
        then pkgs.linuxPackages_latest
        else if cfg.variant == "cachyos"
        then pkgs.linuxPackages_cachyos
        else pkgs.linuxPackages
      );

      kernelParams =
        [
          "quiet"
          "splash"
        ]
        ++ (
          if cfg.hardware == "amd"
          then ["amd_pstate=active"]
          else []
        )
        ++ cfg.extraKernelParams;

      blacklistedKernelModules =
        (
          if cfg.hardware == "nvidia"
          then ["nouveau"]
          else []
        )
        ++ cfg.extraBlacklistedModules;
    };
  };
}
