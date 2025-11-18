{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.pipewire;
  pipewireLowLatencyModule = inputs.nix-gaming.nixosModules.pipewireLowLatency;
in
{
  imports = [
    pipewireLowLatencyModule
  ];
  options = {
    nixos.services.pipewire.enable = mkEnableOption "Enables pipewire";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pwvucontrol
    ];
    services = {
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        jack.enable = true;
        lowLatency = {
          enable = true;
          quantum = 128;
          rate = 48000;
        };
      };
    };
  };
}
