{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkMerge
    genAttrs
    getExe
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
    intelephense
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
    zls
    lldb
  ];

  formatters = with pkgs; [
    alejandra
    prettier
    shfmt
    stylua
    zig
  ];

  mkConfigToml = user: let
  in
    pkgs.writeText "helix-config-${user}.toml" ''
      theme = "darcula-solid"

      [editor]
      color-modes = true
      completion-replace = true
      cursorline = true
      gutters = ["diagnostics", "line-numbers", "spacer", "diff"]
      scrolloff = 3
      true-color = true
      line-number = "relative"

      [editor.cursor-shape]
      insert = "bar"
      normal = "block"
      select = "underline"

      [editor.indent-guides]
      character = "┊"
      render = true

      [editor.inline-diagnostics]
      cursor-line = "disable"

      [editor.lsp]
      display-inlay-hints = true
      display-messages = true

      [editor.soft-wrap]
      enable = true

      [editor.statusline]
      center = ["file-name"]
      left = [
          "mode",
          "selections",
          "file-type",
          "register",
          "spinner",
          "diagnostics",
      ]
      right = ["file-encoding", "file-line-ending", "position", "separator", "total-line-numbers"]
      separator = "/"

      [editor.statusline.mode]
      insert = "INS"
      normal = "NOR"
      select = "SEL"

      [editor.whitespace.characters]
      newline = "↴"
      tab = "⇥"

      [keys.insert]
      C-c = "yank_to_clipboard"
      C-down = "move_visual_line_down"
      C-left = "move_prev_word_start"
      C-right = "move_next_word_start"
      C-up = "move_visual_line_up"
      C-v = "paste_clipboard_after"
      C-x = "completion"
      del = "delete_selection"
      esc = ["collapse_selection", "normal_mode"]

      [keys.normal]
      esc = ["collapse_selection", "keep_primary_selection"]
      C-a = "select_all"
      C-down = "move_visual_line_down"
      C-left = "move_prev_word_start"
      C-right = "move_next_word_start"
      C-up = "move_visual_line_up"
      p = ["paste_clipboard_after"]
      P = ["paste_clipboard_before"]
      y = ["yank_main_selection_to_clipboard"]
      Y = ["extend_to_line_end", "yank_main_selection_to_clipboard", "collapse_selection"]
      C-y = ":yank-diagnostic"
      del = "delete_selection"
      d = "delete_selection"
      D = ["extend_to_line_bounds", "yank_main_selection_to_clipboard", "delete_selection"]
      x = "extend_line_below"
      X = "extend_to_line_bounds"

      [keys.normal.space]
      f = "file_picker"
      F = "file_picker_in_current_directory"
      e = "file_explorer"
      E = "file_explorer_in_current_directory"
      b = "buffer_picker"
      j = "jumplist_picker"
      s = "lsp_or_syntax_symbol_picker"
      S = "lsp_or_syntax_workspace_symbol_picker"
      d = "diagnostics_picker"
      D = "workspace_diagnostics_picker"
      g = "changed_file_picker"
      a = "code_action"

      [keys.normal.space.t]
      d = "goto_type_definition"
      i = "goto_implementation"
      r = "goto_reference"
      t = "goto_definition"
      w = "trim_selections"

      [keys.select]
      P = ["paste_clipboard_before"]
      Y = ["extend_to_line_bounds", "yank_main_selection_to_clipboard", "goto_line_start", "collapse_selection", "normal_mode"]
      d = ["yank_main_selection_to_clipboard", "delete_selection"]
      p = ["replace_selections_with_clipboard"]
      x = ["yank_main_selection_to_clipboard", "delete_selection"]
      y = ["yank_main_selection_to_clipboard", "normal_mode", "flip_selections", "collapse_selection"]

      [keys.select.space]
      P = "paste_before"
      R = "replace_with_yanked"
      c = "toggle_comments"
      f = ":format"
      n = "global_search"
      p = "paste_after"
      q = ":q"
      space = "file_picker"
      w = ":w"
      x = ":buffer-close"
      y = "yank"

      [keys.select.space.t]
      d = "goto_type_definition"
      i = "goto_implementation"
      r = "goto_reference"
      t = "goto_definition"
      w = "trim_selections"
    '';

  mkLanguagesToml = user: let
    flake = ''(builtins.getFlake "/home/${user}/.nix-config")'';
    inherit (config.networking) hostName;
  in
    pkgs.writeText "helix-languages-${user}.toml" ''
      [[language]]
      auto-format = true
      name = "bash"

      [language.formatter]
      args = ["-i", "2"]
      command = "/run/current-system/sw/bin/shfmt"

      [[language]]
      auto-format = true
      language-servers = ["fish-lsp"]
      name = "fish"

      [[language]]
      file-types = ["clj", "cljs", "cljc", "clje", "cljr", "cljx", "edn", "boot", "yuck"]
      injection-regex = "(clojure|clj|edn|boot|yuck)"
      name = "clojure"

      [[language]]
      auto-format = true
      language-servers = ["lua-language-server"]
      name = "lua"

      [language.formatter]
      command = "/run/current-system/sw/bin/stylua"

      [[language]]
      name = "json"

      [language.formatter]
      args = ["fmt", "-", "--ext", "json"]
      command = "/run/current-system/sw/bin/deno"

      [[language]]
      auto-format = false
      name = "common-lisp"

      [[language]]
      auto-format = true
      language-servers = ["markdown-oxide"]
      name = "markdown"

      [language.formatter]
      args = ["fmt", "-", "--ext", "md"]
      command = "/run/current-system/sw/bin/deno"

      [[language]]
      auto-format = true
      language-servers = ["nixd"]
      name = "nix"

      [language.formatter]
      args = ["-q"]
      command = "/run/current-system/sw/bin/alejandra"

      [[language]]
      auto-format = true
      language-servers = ["qmlls"]
      name = "qml"

      [[language]]
      auto-format = true
      language-servers = ["vscode-css-language-server"]
      name = "css"

      [language.formatter]
      args = ["--parser", "css"]
      command = "prettier"

      [[language]]
      auto-format = true
      file-types = ["rs"]
      language-servers = ["rust-analyzer"]
      name = "rust"

      [language.formatter]
      command = "/run/current-system/sw/bin/rustfmt"

      [[language]]
      name = "zig"
      file-types = ["zig", "zon"]
      auto-format = true
      language-servers = [ "zls" ]
      formatter = { command = "/run/current-system/sw/bin/zig" , args = ["fmt", "--stdin"] }

      [language.debugger]
      name = "lldb-dap"
      transport = "stdio"
      command = "/run/current-system/sw/bin/lldb-dap"

      [[language.debugger.templates]]
      name = "binary"
      request = "launch"
      completion = [ { name = "binary", completion = "filename" } ]
      args = { console = "internalConsole", program = "{0}" }

      [[language.debugger.templates]]
      name = "attach"
      request = "attach"
      completion = [ "pid" ]
      args = { console = "internalConsole", pid = "{0}" }

      [[language.debugger.templates]]
      name = "gdbserver attach"
      request = "attach"
      completion = [ { name = "lldb connect url", default = "connect://localhost:3333" }, { name = "file", completion = "filename" }, "pid" ]
      args = { console = "internalConsole", attachCommands = [ "platform select remote-gdb-server", "platform connect {0}", "file {1}", "attach {2}" ] }

      [[language]]
      name = "scss"

      [language.formatter]
      args = ["--parser", "scss"]
      command = "prettier"

      [[language]]
      name = "html"

      [language.formatter]
      args = ["--parser", "html"]
      command = "prettier"

      [language-server.bash-language-server]
      args = ["start"]
      command = "/run/current-system/sw/bin/bash-language-server"

      [language-server.clangd]
      command = "/run/current-system/sw/bin/clangd"

      [language-server.clangd.clangd]
      fallbackFlags = ["-std=c++2b"]

      [language-server.deno-lsp]
      args = ["lsp"]
      command = "/run/current-system/sw/bin/deno"

      [language-server.deno-lsp.config.deno]
      enable = true
      lint = true
      unstable = true

      [language-server.deno-lsp.config.deno.inlayHints.enumMemberValues]
      enabled = true

      [language-server.deno-lsp.config.deno.inlayHints.functionLikeReturnTypes]
      enabled = true

      [language-server.deno-lsp.config.deno.inlayHints.parameterNames]
      enabled = "all"

      [language-server.deno-lsp.config.deno.inlayHints.parameterTypes]
      enabled = true

      [language-server.deno-lsp.config.deno.inlayHints.propertyDeclarationTypes]
      enabled = true

      [language-server.deno-lsp.config.deno.inlayHints.variableTypes]
      enabled = true

      [language-server.deno-lsp.config.deno.suggest]
      completeFunctionCalls = false

      [language-server.deno-lsp.config.deno.suggest.imports.hosts]
      "https://deno.land" = true

      [language-server.deno-lsp.environment]
      NO_COLOR = "1"

      [language-server.fish-lsp]
      args = ["start"]
      command = "/run/current-system/sw/bin/fish-lsp"

      [language-server.lua-language-server]
      command = "/run/current-system/sw/bin/lua-language-server"

      [language-server.markdown-oxide]
      command = "/run/current-system/sw/bin/markdown-oxide"

      [language-server.phpactor]
      args = ["language-server"]
      command = "/run/current-system/sw/bin/intelephense"

      [language-server.qmlls]
      args = ["-E"]
      command = "/run/current-system/sw/bin/qmlls"

      [language-server.rust-analyzer]
      command = "/run/current-system/sw/bin/rust-analyzer"

      [language-server.typescript-language-server]
      args = ["--stdio"]
      command = "/run/current-system/sw/bin/typescript-language-server"

      [language-server.zls]
      command = "/run/current-system/sw/bin/zls"

      [language-server.typescript-language-server.config]
      hostInfo = "helix"

      [language-server.typescript-language-server.config.javascript.inlayHints]
      includeInlayEnumMemberValueHints = true
      includeInlayFunctionLikeReturnTypeHints = true
      includeInlayFunctionParameterTypeHints = true
      includeInlayParameterNameHints = "all"
      includeInlayParameterNameHintsWhenArgumentMatchesName = true
      includeInlayPropertyDeclarationTypeHints = true
      includeInlayVariableTypeHints = true

      [language-server.typescript-language-server.config.typescript.inlayHints]
      includeInlayEnumMemberValueHints = true
      includeInlayFunctionLikeReturnTypeHints = true
      includeInlayFunctionParameterTypeHints = true
      includeInlayParameterNameHints = "all"
      includeInlayParameterNameHintsWhenArgumentMatchesName = true
      includeInlayPropertyDeclarationTypeHints = true
      includeInlayVariableTypeHints = true

      [language-server.typescript-language-server.config.typescript-language-server.source.addMissingImports]
      ts = true

      [language-server.typescript-language-server.config.typescript-language-server.source.fixAll]
      ts = true

      [language-server.typescript-language-server.config.typescript-language-server.source.organizeImports]
      ts = true

      [language-server.typescript-language-server.config.typescript-language-server.source.removeUnusedImports]
      ts = true

      [language-server.typescript-language-server.config.typescript-language-server.source.sortImports]
      ts = true

      [language-server.vscode-css-language-server]
      args = ["--stdio"]
      command = "/run/current-system/sw/bin/vscode-css-language-server"

      [language-server.vscode-css-language-server.config]
      provideFormatter = true

      [language-server.vscode-css-language-server.config.css.validate]
      enable = true

      [language-server.vscode-css-language-server.config.scss.validate]
      enable = true

      [language-server.nixd]
      command = "${getExe pkgs.nixd}"

      [language-server.nixd.config.nixd.nixpkgs]
      expr = 'import ${flake}.inputs.nixpkgs { }'

      [language-server.nixd.config.nixd.options.nixos]
      expr = '${flake}.nixosConfigurations.${hostName}.options'
    '';
in {
  options.cnix.programs.helix = {
    enable = mkEnableOption "the Helix editor";
    languages.enable = mkEnableOption "Helix language servers and formatters";
    rust.enable = mkEnableOption "the Rust toolchain (rust-analyzer, rust-src)";
    frontend.enable = mkEnableOption "the frontend toolchain (TS, PHP, QML, Deno)";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [helixPkg];
      environment.variables.EDITOR = "hx";
    }
    (mkIf cfg.languages.enable {
      environment.systemPackages = languageServers ++ formatters;
    })
    (mkIf cfg.rust.enable {
      environment.systemPackages = [rustToolchain];
    })
    (mkIf cfg.frontend.enable {
      environment.systemPackages = frontendToolchain;
    })
    (mkIf (acct.defaultUsers != []) {
      hjem.users = genAttrs acct.defaultUsers (user: {
        files = {
          ".config/helix/config.toml" = {
            source = mkConfigToml user;
            clobber = true;
          };
          ".config/helix/languages.toml" = {
            source = mkLanguagesToml user;
            clobber = true;
          };
        };
      });
    })
  ]);
}
