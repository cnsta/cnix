{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkIf;
  cfg = config.nixos.boot.kernel;
in {
  options = {
    nixos.boot.kernel = {
      variant = mkOption {
        type = lib.types.enum ["stable" "latest" "cachyos"];
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
        description = "Additional kernel nixos.to blacklist.";
      };
    };
  };

  config = {
    boot = {
      consoleLogLevel = 3;

      kernelPackages = let
        variant = cfg.variant or "latest"; # Ensure a default value
      in
        if variant == "stable"
        then pkgs.linuxPackages
        else if variant == "latest"
        then pkgs.linuxPackages_latest
        else if variant == "cachyos"
        then pkgs.linuxPackages_cachyos
        else throw "Unknown kernel variant: ${variant}";

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

    # chaotic = mkIf (cfg.variant == "cachyos") {
    #   environment.systemPackages = [pkgs.scx.lavd];
    # };
  };
}
