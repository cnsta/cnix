lib: {
  bgs = rec {
    files = {
      wallpaper_1 = "~/media/images/backgrounds/bg_1.jpg";
      wallpaper_2 = "~/media/images/backgrounds/bg_2.jpg";
      wallpaper_3 = "~/media/images/backgrounds/bestlialis_1k.jpeg";
      wallpaper_4 = "~/media/images/backgrounds/bestlialis_2k.jpeg";
      wallpaper_5 = "~/media/images/backgrounds/genesis_1k.jpg";
      wallpaper_6 = "~/media/images/backgrounds/genesis_2k.jpg";
      wallpaper_7 = "~/media/images/backgrounds/pepe_vert.jpg";
      wallpaper_8 = "~/media/images/backgrounds/resadversae_1k.jpg";
      wallpaper_9 = "~/media/images/backgrounds/resadversae_2k.jpg";
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
