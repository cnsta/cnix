{pkgs, ...}: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code-symbols
    font-awesome
    recursive
    input-fonts
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "FiraCode"
        "FiraMono"
        "Iosevka"
        "3270"
        "DroidSansMono"
        "SourceCodePro"
        "UbuntuMono"
        "Overpass"
        "Monoid"
        "Mononoki"
        "Hack"
        "IBMPlexMono"
      ];
    })
  ];
}
