{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.cnix.programs.nh;
  user = config.cnix.settings.accounts.username;
in {
  options.cnix.programs.nh = {
    enable = mkEnableOption "Enables nix helper";
    clean = {
      enable = mkEnableOption "Enables nix helper cleaning";
      extraArgs = mkOption {
        type = lib.types.str;
        description = "Extra arguments for the clean command";
        default = "";
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      variables.NH_FLAKE = "/home/${user}/.nix-config";
      systemPackages = with pkgs; [
        nvd
        dix
        nix-output-monitor
      ];
    };

    programs = {
      nh = {
        enable = cfg.enable;
        clean = {
          enable = cfg.clean.enable;
          extraArgs = cfg.clean.extraArgs;
        };
      };
    };
  };
}
