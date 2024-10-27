{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.yazi;
in {
  imports = [
    ./theme
  ];

  options = {
    home.programs.yazi.enable = mkEnableOption "Enables yazi";
  };
  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;

      package = pkgs.yazi;

      enableBashIntegration = config.programs.bash.enable;
      enableZshIntegration = config.programs.zsh.enable;

      settings = {
        manager = {
          layout = [1 4 3];
          sort_by = "alphabetical";
          sort_sensitive = true;
          sort_reverse = false;
          sort_dir_first = true;
          linemode = "none";
          show_hidden = false;
          show_symlink = true;
        };

        preview = {
          tab_size = 2;
          max_width = 600;
          max_height = 900;
          cache_dir = config.xdg.cacheHome;
        };
      };
    };
  };
}
