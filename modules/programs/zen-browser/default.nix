{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.zen-browser;
in
{
  options.cnix.programs.zen-browser.enable = mkEnableOption "Enables zen-browser";

  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
