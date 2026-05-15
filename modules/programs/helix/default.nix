{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    genAttrs
    ;
  cfg = config.cnix.programs.helix;
  acct = config.cnix.settings.accounts;
  helixPkg = inputs.helix-flake.packages.${pkgs.stdenv.hostPlatform.system}.default;

  rustPkgs = pkgs.extend inputs.rust-overlay.overlays.default;
  rustToolchain = rustPkgs.rust-bin.stable.latest.default.override {
    extensions = [
      "rust-analyzer"
      "rust-src"
    ];
  };

  languageServers = with pkgs; [
    bash-language-server
    clang-tools
    fish-lsp
    lua-language-server
    markdown-oxide
    nixd
    phpactor
    typescript-language-server
    vscode-langservers-extracted
    kdePackages.qtdeclarative
  ];

  formatters = with pkgs; [
    deno
    nixfmt
    prettier
    shfmt
    stylua
  ];

  languagePkgs = [ rustToolchain ] ++ languageServers ++ formatters;
in
{
  options.cnix.programs.helix.enable = mkEnableOption "the Helix editor";
  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ helixPkg ] ++ languagePkgs;
      environment.variables.EDITOR = "hx";
    }
    (mkIf (acct.defaultUsers != [ ]) {
      hjem.users = genAttrs acct.defaultUsers (_: {
        xdg.config.files = {
          "helix/config.toml".source = ./config.toml;
          "helix/languages.toml".source = ./languages.toml;
        };
      });
    })
  ]);
}
