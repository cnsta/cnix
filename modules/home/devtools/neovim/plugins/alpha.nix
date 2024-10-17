{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = alpha-nvim;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          local alpha = require("alpha")
          local dashboard = require("alpha.themes.dashboard")

          dashboard.section.header.val = {
          	"                                                     ",
          	"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
          	"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
          	"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
          	"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
          	"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
          	"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
          	"                                                     ",
          }
          dashboard.section.header.opts.hl = "Title"

          dashboard.section.buttons.val = {
          	dashboard.button("n", "󰈔 New file", ":enew<CR>"),
          	dashboard.button("e", " Explore", ":Explore<CR>"),
          	dashboard.button("g", " Git summary", ":Git | :only<CR>"),
          	dashboard.button("c", "  Nix config flake", ":e ~/.nix-config/flake.nix<CR>"),
          }

          alpha.setup(dashboard.opts)
          vim.keymap.set("n", "<space>h", ":Alpha<CR>", { desc = "Open home dashboard" })
        '';
    }
  ];
}
