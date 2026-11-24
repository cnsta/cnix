{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cnix.programs.foot;
in {
  options.cnix.programs.foot.enable = mkEnableOption "Enables foot programs";

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      package = pkgs.foot;
      settings = {
        main = {
          font = "Input Mono Compressed:size=12";
          box-drawings-uses-font-glyphs = "yes";
          dpi-aware = "no";
          pad = "3x1";
          term = "xterm-256color";
        };

        environment = {
        };

        bell = {
          urgent = "no";
          notify = "no";
          visual = "no";
          command = "no";
          command-focused = "no";
        };

        scrollback = {
          lines = "100";
        };

        url = {
        };

        cursor = {
          style = "block";
          blink = "no";
        };

        mouse = {
          hide-when-typing = "no";
        };

        touch = {
        };

        colors-dark = {
          alpha = "0.9";
          background = "282828";
          foreground = "ebdbb2";
          regular0 = "282828";
          regular1 = "cc241d";
          regular2 = "98971a";
          regular3 = "d79921";
          regular4 = "458588";
          regular5 = "b16286";
          regular6 = "689d6a";
          regular7 = "a89984";
          bright0 = "928374";
          bright1 = "fb4934";
          bright2 = "b8bb26";
          bright3 = "fabd2f";
          bright4 = "83a598";
          bright5 = "d3869b";
          bright6 = "8ec07c";
          bright7 = "ebdbb2";
        };

        csd = {
        };

        key-bindings = {
        };

        search-bindings = {
        };

        url-bindings = {
        };

        text-bindings = {
        };

        mouse-bindings = {
        };
      };
    };
  };
}
