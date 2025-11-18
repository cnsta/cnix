{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.nixos.programs.gamemode;
in
{
  options = {
    nixos.programs.gamemode = {
      enable = mkEnableOption "Enables gamemode";
      optimizeGpu.enable = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to apply GPU optimizations.";
      };
    };
  };
  config = mkIf cfg.enable {
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          inhibit_screensaver = 1;
          softrealtime = "auto";
          # renice = 15;
        };
        gpu = mkIf cfg.optimizeGpu.enable {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          amd_performance_level = "high";
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
  };
}
