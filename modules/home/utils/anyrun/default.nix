{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.utils.anyrun;
in {
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];
  options = {
    home.utils.anyrun.enable = mkEnableOption "Enables anyrun";
  };
  config = mkIf cfg.enable {
    programs.anyrun = {
      enable = true;

      #extraCss = builtins.readFile (./. + "/style-dark.css");
    };
  };
}
