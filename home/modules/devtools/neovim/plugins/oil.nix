{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = oil-nvim;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          require('oil').setup{
            buf_options = {
              buflisted = true,
              bufhidden = "delete",
            },
            cleanup_delay_ms = false,
            use_default_keymaps = false,
            keymaps = {
              ["<CR>"] = "actions.select",
              ["-"] = "actions.parent",
              ["_"] = "actions.open_cwd",
              ["`"] = "actions.cd",
              ["~"] = "actions.tcd",
              ["gc"] = "actions.close",
              ["gr"] = "actions.refresh",
              ["gs"] = "actions.change_sort",
              ["gx"] = "actions.open_external",
              ["g."] = "actions.toggle_hidden",
              ["g\\"] = "actions.toggle_trash",
            },
          }
        '';
    }
  ];
}
