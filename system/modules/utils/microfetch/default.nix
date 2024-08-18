{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.utils.microfetch;
in {
  options = {
    modules.utils.microfetch.enable = mkEnableOption "Enables microfetch";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [inputs.microfetch.packages.x86_64-linux.default];
  };
}
