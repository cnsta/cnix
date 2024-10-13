{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.sysd.system.pipewire;
in {
  options = {
    systemModules.sysd.system.pipewire.enable = mkEnableOption "Enables pipewire";
  };
  config = mkIf cfg.enable {
    hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
