{
  programs.nixvim.autoCmd = [
    # Open help in a vertical split
    {
      event = "FileType";
      pattern = "help";
      command = "wincmd L";
    }

    # Enable spellcheck for some filetypes
    {
      event = "FileType";
      pattern = [
        "tex"
        "latex"
        "markdown"
      ];
      command = "setlocal spell spelllang=en,se";
    }
    {
      event = "TextYankPost";
      desc = "Highlight when yanking (copying) text";
      # group = "vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true })";
      callback = {
        __raw = "function()
    vim.highlight.on_yank()
  end";
      };
    }
  ];
}
