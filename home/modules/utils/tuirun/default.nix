{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.userModules.utils.tuirun;
in {
  imports = [
    inputs.tuirun.homeManagerModules.default
  ];
  options = {
    userModules.utils.tuirun.enable = mkEnableOption "Enables tuirun";
  };
  config = mkIf cfg.enable {
    programs.tuirun = {
      enable = true;
      config = {
        plugins = with inputs.tuirun.packages.${pkgs.system}; [
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
