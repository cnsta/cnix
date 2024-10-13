{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userModules.devtools.nixvim.plugins.none-ls;
in {
  options = {
    userModules.devtools.nixvim.plugins.none-ls.enable = mkEnableOption "Enables None-LS plugin for nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.none-ls = {
      enable = true;
      settings = {
        cmd = ["bash -c nvim"];
        debug = true;
      };
      sources = {
        code_actions = {
          statix.enable = true;
          gitsigns.enable = true;
        };
        diagnostics = {
          statix.enable = true;
          deadnix.enable = true;
          pylint.enable = true;
          checkstyle.enable = true;
        };
        formatting = {
          alejandra.enable = true;
          stylua.enable = true;
          shfmt.enable = true;
          google_java_format.enable = false;
          prettier = {
            enable = true;
            disableTsServerFormatter = true;
          };
          prettierd.enable = true;
          phpcsfixer.enable = true;
          xmllint.enable = true;
          yamlfmt.enable = true;
          black = {
            enable = true;
            settings = ''
              {
                extra_args = { "--fast" };
              }
            '';
          };
        };
        completion = {
          luasnip.enable = true;
          spell.enable = true;
        };
      };
    };
  };
}
