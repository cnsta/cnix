{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

  programs.anyrun = {
    enable = true;

    #extraCss = builtins.readFile (./. + "/style-dark.css");
  };
}
