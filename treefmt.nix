_: {
  projectRootFile = "flake.nix";
  programs = {
    alejandra.enable = true;
    prettier = {
      enable = true;
      excludes = ["*.js" "*.md" "*.ts"];
    };
  };
}
