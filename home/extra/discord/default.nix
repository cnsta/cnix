{pkgs, ...}: {
  home.packages = with pkgs; [vesktop];

  xdg.configFile."vesktop/themes/base16.css".text =
    /*
    css
    */
    ''
      @import url(https://mwittrien.github.io/BetterDiscordAddons/Themes/DiscordRecolor/DiscordRecolor.css);

      :root {
        --accentcolor: 137, 180, 130;
        --accentcolor2: 211, 134, 155;
        --linkcolor: 125, 174, 163;
        --mentioncolor: 211, 134, 155;
        --textbrightest: 221, 199, 161;
        --textbrighter: 212, 190, 152;
        --textbright: 168, 153, 132;
        --textdark: 146, 131, 116;
        --textdarker: 146, 131, 116;
        --textdarkest: 80, 80, 80;
        --font: Input Sans Narrow 10;
        --backgroundaccent: 80, 73, 69;
        --backgroundprimary: 60, 56, 54;
        --backgroundsecondary: 50, 48, 47;
        --backgroundsecondaryalt: 40, 40, 40;
        --backgroundtertiary: 29, 32, 33;
        --backgroundfloating: 20, 22, 23;
        --settingsicons: 1;
      }
    
'';
}
