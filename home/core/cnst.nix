{
  home.sessionVariables = {
    BROWSER = "firefox";
    EDITOR = "nvim";
    TERM = "foot";
  };
  imports = [
    ./system/polkit.nix
    ./git
    ./gui
    ./shell/cnst.nix
    ./appearance
  ];
}
