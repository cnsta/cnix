{
  config,
  inputs,
  lib,
  ...
}:
with lib; let
  cfg = config.cnix.programs.byt;
in {
  imports = [
    inputs.byt.nixosModules.default
  ];
  options.cnix.programs.byt.enable = mkEnableOption "Enables byt";

  config = mkIf cfg.enable {
    programs.byt.enable = true;
  };
}
