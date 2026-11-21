{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption versionAtLeast;
  cfg = config.cnix.programs.yazi;
  yazi = config.programs.yazi.package;
in {
  options.cnix.programs.yazi.enable = mkEnableOption "yazi";

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = versionAtLeast yazi.version "26.9.1";
        message = "kanagawa-paper.yazi needs yazi >= 26.9.1, got ${yazi.version}; update nixpkgs";
      }
    ];

    programs.yazi = {
      enable = true;
      package = pkgs.yazi.override {_7zz = pkgs._7zz-rar;};
      flavors.kanagawa-paper = inputs.kanagawa-paper-yazi;
      settings = {
        yazi.mgr.sort_sensitive = true;
        theme.flavor = {
          dark = "kanagawa-paper";
          light = "kanagawa-paper";
        };
      };
    };

    environment.systemPackages = mkIf config.programs.fish.enable [
      (pkgs.writeTextDir "share/fish/vendor_functions.d/y.fish" ''
        function y
            set tmp (mktemp -t "yazi-cwd.XXXXXX")
            command yazi $argv --cwd-file="$tmp"
            if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
                builtin cd -- "$cwd"
            end
            command rm -f -- "$tmp"
        end
      '')
    ];
  };
}
