{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.home.devtools.nixvim.plugins.rustaceanvim;
in {
  options.home.devtools.nixvim.plugins.rustaceanvim = {
    enable = mkEnableOption "Whether to enable rustaceanvim.";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins.rustaceanvim = {
        enable = true;

        settings.server = {
          default_settings.rust-analyzer = {
            cargo.features = "all";
            checkOnSave = true;
            check.command = "clippy";
            rustc.source = "discover";
          };
        };
      };
    };
  };
}
