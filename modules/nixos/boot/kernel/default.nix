{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.nixos.boot.kernel;

  hasHardware = hw: builtins.elem hw cfg.hardware;
in {
  options = {
    nixos.boot.kernel = {
      variant = mkOption {
        type = types.enum ["stable" "latest" "cachyos"];
        default = "latest";
        description = "Kernel variant to use.";
      };

      hardware = mkOption {
        type = types.listOf (types.enum ["amd" "intel" "nvidia"]);
        default = [];
        description = "List of hardware types (e.g. GPU and CPU vendors) to configure kernel settings for.";
      };

      extraKernelParams = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Additional kernel parameters.";
      };

      extraBlacklistedModules = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Additional kernel modules to blacklist.";
      };
    };
  };

  config = {
    boot = {
      consoleLogLevel = 3;

      kernelPackages = let
        variant = cfg.variant or "latest";
      in
        if variant == "stable"
        then pkgs.linuxPackages
        else if variant == "latest"
        then pkgs.linuxPackages_latest
        else if variant == "cachyos"
        then pkgs.linuxPackages_cachyos
        else throw "Unknown kernel variant: ${variant}";

      kernelParams =
        ["quiet" "splash"]
        ++ (
          if hasHardware "amd"
          then ["amd_pstate=active"]
          else []
        )
        ++ (
          if hasHardware "intel"
          then []
          else []
        )
        ++ (
          if hasHardware "nvidia"
          then []
          else []
        )
        ++ cfg.extraKernelParams;

      blacklistedKernelModules =
        (
          if hasHardware "amd"
          then []
          else []
        )
        ++ (
          if hasHardware "intel"
          then []
          else []
        )
        ++ (
          if hasHardware "nvidia"
          then ["nouveau"]
          else []
        )
        ++ cfg.extraBlacklistedModules;
    };
  };
}
