{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    mkEnableOption
    mkIf
    ;
  cfg = config.cnix.settings.boot.kernel;
in {
  imports = [
    ./security.nix
  ];

  options = {
    cnix.settings.boot.kernel = {
      variant = mkOption {
        type = types.enum [
          "stable"
          "latest"
        ];
        default = "latest";
        description = ''
          Kernel variant to use. `stable` is nixpkgs' default kernel (the newest
          LTS); use it on ZFS hosts.
        '';
      };

      amdOverdrive.enable = mkEnableOption "Enable AMD pstate/overdrive";

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
    hardware.i2c = {
      enable = true;
      group = "i2c";
    };
    boot = {
      consoleLogLevel = 3;

      kernelPackages = let
        variant = cfg.variant or "latest";
      in
        if variant == "stable"
        then pkgs.linuxPackages
        else if variant == "latest"
        then pkgs.linuxPackages_latest
        else throw "Unknown kernel variant: ${variant}";

      kernelParams = ["quiet" "splash"] ++ cfg.extraKernelParams;

      blacklistedKernelModules = cfg.extraBlacklistedModules;
    };
    hardware.amdgpu.overdrive.enable = mkIf cfg.amdOverdrive.enable true;
  };
}
