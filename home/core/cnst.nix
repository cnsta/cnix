{
  home.sessionVariables = {
    BROWSER = "firefox";
    EDITOR = "nvim";
    TERM = "kitty";
  };
  imports = [
    ./git
    ./gui
    ./shell/cnst.nix
    ./appearance
  ];
}
