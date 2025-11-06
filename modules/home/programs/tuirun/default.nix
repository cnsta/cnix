{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.tuirun;
in
{
  imports = [
    inputs.tuirun.homeManagerModules.default
  ];
  options = {
    home.programs.tuirun.enable = mkEnableOption "Enables tuirun";
  };
  config = mkIf cfg.enable {
    programs.tuirun = {
      enable = true;
      config = {
        plugins = with inputs.tuirun.packages.${pkgs.stdenv.hostPlatform.system}; [
          runner
        ];
        closeOnClick = true;
        cursor = "Underscore";
      };
      extraConfigFiles = {
        "runner.ron".text = ''
          Config(
            desktop_actions: false,
            terminal: Some("foot"),
            max_entries: 5,
          )
        '';
      };
    };
  };
}
