{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.nixos.programs.nh;
  user = config.settings.accounts.username;
in
{
  options = {
    nixos.programs.nh = {
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
