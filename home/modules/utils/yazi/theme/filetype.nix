{
  programs.yazi.theme.filetype.rules = [
    # Images
    {
      mime = "image/*";
      fg = "#83a598";
    }

    # Videos
    {
      mime = "video/*";
      fg = "#b8bb26";
    }
    {
      mime = "audio/*";
      fg = "#b8bb26";
    }

    # Archives
    {
      mime = "application/zip";
      fg = "#fe8019";
    }
    {
      mime = "application/gzip";
      fg = "#fe8019";
    }
    {
      mime = "application/x-tar";
      fg = "#fe8019";
    }
    {
      mime = "application/x-bzip";
      fg = "#fe8019";
    }
    {
      mime = "application/x-bzip2";
      fg = "#fe8019";
    }
    {
      mime = "application/x-7z-compressed";
      fg = "#fe8019";
    }
    {
      mime = "application/x-rar";
      fg = "#fe8019";
    }

    # Fallback
    {
      name = "*";
      fg = "#a89984";
    }
    {
      name = "*/";
      fg = "#83a598";
    }
  ];
}
