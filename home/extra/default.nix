{
  home-manager = {
    cnst.imports = [
      ./firefox
      ./neovim
      ./zellij
      ./cnst-pkgs
    ];
    adam.imports = [
      ./firefox
      ./neovim
      ./zellij
      ./adam-pkgs
    ];
  };
}
