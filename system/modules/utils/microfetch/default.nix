{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.utils.microfetch;
in {
  options = {
    systemModules.utils.microfetch.enable = mkEnableOption "Enables microfetch";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [inputs.microfetch.packages.x86_64-linux.default];
  };
}
