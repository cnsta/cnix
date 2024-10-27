{
  programs.yazi.theme.manager = {
    cwd = {fg = "#83a598";};
    # Hovered
    hovered = {
      fg = "#282828";
      bg = "#83a598";
    };

    preview_hovered = {underline = true;};

    # Find
    find_keyword = {
      fg = "#b8bb26";
      italic = true;
    };
    find_position = {
      fg = "#fe8019";
      bg = "reset";
      italic = true;
    };

    # Marker
    marker_selected = {
      fg = "#b8bb26";
      bg = "#b8bb26";
    };
    marker_copied = {
      fg = "#b8bb26";
      bg = "#b8bb26";
    };
    marker_cut = {
      fg = "#fb4934";
      bg = "#fb4934";
    };

    # Tab
    tab_active = {
      fg = "#282828";
      bg = "#504945";
    };
    tab_inactive = {
      fg = "#a89984";
      bg = "#3c3836";
    };
    tab_width = 1;

    # Border;
    border_symbol = "│";
    border_style = {fg = "#665c54";};

    # Offset;
    folder_offset = [1 0 1 0];
    preview_offset = [1 1 1 1];

    # Highlighting;
    syntect_theme = "";
  };
}
