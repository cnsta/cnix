{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.pipewire;
in
{
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
      };
    };
  };
}
