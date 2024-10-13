{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.systemModules.gaming.gamemode;
  pipewireLowLatencyModule = inputs.nix-gaming.nixosModules.pipewireLowLatency;
in {
  imports = [
    pipewireLowLatencyModule
  ];
  options = {
    systemModules.gaming.gamemode = {
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
    # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
    services.pipewire.lowLatency.enable = true;
  };
}
