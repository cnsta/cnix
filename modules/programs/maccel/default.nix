{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.maccel;
in {
  imports = [
    inputs.maccel.nixosModules.default
  ];
  options.cnix.programs.maccel.enable = mkEnableOption "Enables maccel";

  config = mkIf cfg.enable {
    hardware.maccel = {
      enable = true;
      enableCli = true;
      parameters = {
        mode = "linear";
        sensMultiplier = 1.0;
        acceleration = 0.3;
        offset = 2.0;
        outputCap = 2.0;
      };
    };
  };
}
