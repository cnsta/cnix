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

    resolve =
      name:
      if name == null then
        null
      else if files ? ${name} then
        files.${name}
      else
        null;

    safe = val: val != null;

    resolveList =
      mappings:
      builtins.filter safe (
        map (m: if m.bg == null then null else "${m.monitor},${resolve m.bg}") mappings
      );

    all = builtins.attrValues files;
  };
}
