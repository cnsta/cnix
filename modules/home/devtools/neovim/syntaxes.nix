{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.neovim = {
    extraConfig =
      lib.mkAfter # vim
      
      ''
        function! SetCustomKeywords()
          syn match Todo  /TODO/
          syn match Done  /DONE/
          syn match Start /START/
          syn match End   /END/
        endfunction

        autocmd Syntax * call SetCustomKeywords()
      '';
    plugins = with pkgs.vimPlugins; [
      rust-vim
      dart-vim-plugin
      plantuml-syntax
      vim-markdown
      vim-nix
      vim-toml
      kotlin-vim
      haskell-vim
      pgsql-vim
      vim-terraform
      vim-jsx-typescript
      vim-caddyfile

      {
        plugin = vimtex;
        config = let
          viewMethod =
            if config.programs.zathura.enable
            then "zathura"
            else "general";
        in
          /*
          vim
          */
          ''
            let g:vimtex_view_method = '${viewMethod}'
            "Don't open automatically
            let g:vimtex_quickfix_mode = 0
          '';
      }
    ];
  };
}
