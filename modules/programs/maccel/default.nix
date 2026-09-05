{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.maccel;
  user = config.cnix.settings.accounts.username;
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
        sensMultiplier = 1.0;
        yxRatio = 1.0;
        inputDpi = 1000.0;
        angleRotation = 0.0;
        mode = "synchronous";
        gamma = 0.8;
        smooth = 1.0;
        motivity = 1.3;
        syncSpeed = 8.0;
      };
    };
    users.groups.maccel.members = [user];
  };
}
