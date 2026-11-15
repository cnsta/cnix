{
  config,
  inputs,
  lib,
  ...
}:
with lib; let
  cfg = config.cnix.programs.silt;
in {
  imports = [
    inputs.silt.nixosModules.default
  ];
  options.cnix.programs.silt.enable = mkEnableOption "Enables silt";

  config = mkIf cfg.enable {
    programs.silt.enable = true;
  };
}
