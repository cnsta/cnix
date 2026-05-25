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

  frontendToolchain = with pkgs; [
    phpactor
    typescript-language-server
    vscode-langservers-extracted
    kdePackages.qtdeclarative
    deno
  ];

  languageServers = with pkgs; [
    bash-language-server
    clang-tools
    fish-lsp
    lua-language-server
    markdown-oxide
    nixd
  ];

  formatters = with pkgs; [
    nixfmt
    prettier
    shfmt
    stylua
  ];
in
{
  options.cnix.programs.helix = {
    enable = mkEnableOption "the Helix editor";
    languages.enable = mkEnableOption "Helix language servers and formatters";
    rust.enable = mkEnableOption "the Rust toolchain (rust-analyzer, rust-src)";
    frontend.enable = mkEnableOption "the frontend toolchain (TS, PHP, QML, Deno)";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ helixPkg ];
      environment.variables.EDITOR = "hx";
    }
    (mkIf cfg.languages.enable {
      environment.systemPackages = languageServers ++ formatters;
    })
    (mkIf cfg.rust.enable {
      environment.systemPackages = [ rustToolchain ];
    })
    (mkIf cfg.frontend.enable {
      environment.systemPackages = frontendToolchain;
    })
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
