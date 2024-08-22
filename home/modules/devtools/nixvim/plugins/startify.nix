{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.nixvim.plugins.startify;
in {
  options = {
    modules.devtools.nixvim.plugins.startify.enable = mkEnableOption "Enables Startify plugin for nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.startify = {
      enable = true;

      settings = {
        custom_header = [
          ""
          "     ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
          "     ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
          "     ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
          "     ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
          "     ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
          "     ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
        ];

        change_to_dir = false;
        use_unicode = true;
        lists = [{type = "dir";}];
        files_number = 30;
        skiplist = ["flake.lock"];
      };
    };
  };
}
