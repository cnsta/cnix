{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.utils.microfetch;
in {
  options = {
    system.utils.microfetch.enable = mkEnableOption "Enables microfetch";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [inputs.microfetch.packages.x86_64-linux.default];
  };
}
