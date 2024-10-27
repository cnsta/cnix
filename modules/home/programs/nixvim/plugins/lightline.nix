{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.home.devtools.nixvim.plugins.lightline;
in {
  options = {
    home.devtools.nixvim.plugins.lightline.enable = mkEnableOption "Enables lightline plugin for nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.lightline = {
      enable = true;
      settings = {
        colorscheme = "apprentice";
        active = {
          right = [
            [
              "lineinfo"
            ]
            [
              "percent"
            ]
            [
              "fileformat"
              "fileencoding"
              "filetype"
            ]
          ];
        };
        component = {
          charvaluehex = "0x%B";
          lineinfo = "%3l:%-2v%<";
        };
        component_function = {
          gitbranch = "FugitiveHead";
        };
        inactive = [];
        mode_map = {
          "<C-s>" = "SB";
          "<C-v>" = "VB";
          i = "I";
          n = "N";
          v = "V";
        };
      };
    };
  };
}
