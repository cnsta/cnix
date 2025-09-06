lib: {
  bgs = rec {
    files = {
      wallpaper_1 = "~/media/images/bg_1.jpg";
      wallpaper_2 = "~/media/images/bg_2.jpg";
      wallpaper_3 = "~/media/images/bg_3.jpg";
      wallpaper_4 = "~/media/images/waterwindow.jpg";
      wallpaper_5 = "~/media/images/barngreet.png";
    };

    list = builtins.attrNames files;

    resolve = name: if name == null then null else files.${name};

    resolveList = names: builtins.filter (x: x != null) (map resolve names);

    all = builtins.attrValues files;
  };
}
