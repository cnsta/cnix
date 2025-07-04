{
  pkgs,
  lib,
  ...
}: {
  programs.helix.languages = {
    language = let
      deno = lang: {
        command = lib.getExe pkgs.deno;
        args = ["fmt" "-" "--ext" lang];
      };

      prettier = lang: {
        command = "prettier";
        args = ["--parser" lang];
      };
      prettierLangs = map (e: {
        name = e;
        formatter = prettier e;
      });
      langs = ["css" "scss" "html"];
    in
      [
        {
          name = "bash";
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.shfmt;
            args = ["-i" "2"];
          };
        }
        {
          name = "fish";
          auto-format = true;
        }
        {
          name = "clojure";
          injection-regex = "(clojure|clj|edn|boot|yuck)";
          file-types = ["clj" "cljs" "cljc" "clje" "cljr" "cljx" "edn" "boot" "yuck"];
        }
        {
          name = "cmake";
          auto-format = true;
          language-servers = ["cmake-language-server"];
          formatter = {
            command = lib.getExe pkgs.cmake-format;
            args = ["-"];
          };
        }
        {
          name = "lua";
          auto-format = true;
          language-servers = ["lua-language-server"];
          formatter = {
            command = lib.getExe pkgs.stylua;
          };
        }
        {
          name = "javascript";
          auto-format = true;
          language-servers = ["dprint" "typescript-language-server"];
        }
        {
          name = "json";
          formatter = deno "json";
        }
        {
          name = "common-lisp";
          file-types = ["kbd"];
          auto-format = true;
        }
        {
          name = "markdown";
          auto-format = true;
          formatter = deno "md";
        }
        {
          name = "nix";
          auto-format = true;
          language-servers = ["nil"];
          formatter = {
            command = "${pkgs.alejandra}/bin/alejandra";
            args = ["-q"];
          };
        }
        {
          name = "python";
          language-servers = ["pylsp"];
          formatter = {
            command = lib.getExe pkgs.black;
            args = ["-" "--quiet" "--line-length 100"];
          };
        }
        {
          name = "qml";
          auto-format = true;
          language-servers = ["qmlls"];
        }
        {
          name = "typescript";
          auto-format = true;
          language-servers = ["dprint" "typescript-language-server"];
        }
        # {
        #   name = "php";
        #   auto-format = true;
        #   language-servers = ["phpactor"];
        #   formatter = {
        #     command = lib.getExe pkgs.php84Packages.php-cs-fixer;
        #   };
        # }
        {
          name = "css";
          auto-format = true;
          language-servers = ["vscode-css-language-server"];
        }
        {
          name = "rust";
          auto-format = true;
          file-types = ["rs"];
          language-servers = ["rust-analyzer"];
          formatter = {
            command = lib.getExe pkgs.rustfmt;
          };
        }
      ]
      ++ prettierLangs langs;

    language-server = {
      phpactor = {
        command = lib.getExe pkgs.phpactor;
        args = ["language-server"];
      };

      bash-language-server = {
        command = lib.getExe pkgs.bash-language-server;
        args = ["start"];
      };

      clangd = {
        command = "${pkgs.clang-tools}/bin/clangd";
        clangd.fallbackFlags = ["-std=c++2b"];
      };

      cmake-language-server = {
        command = lib.getExe pkgs.cmake-language-server;
      };

      lua-language-server = {
        command = lib.getExe pkgs.lua-language-server;
      };

      deno-lsp = {
        command = lib.getExe pkgs.deno;
        args = ["lsp"];
        environment.NO_COLOR = "1";
        config.deno = {
          enable = true;
          lint = true;
          unstable = true;
          suggest = {
            completeFunctionCalls = false;
            imports = {hosts."https://deno.land" = true;};
          };
          inlayHints = {
            enumMemberValues.enabled = true;
            functionLikeReturnTypes.enabled = true;
            parameterNames.enabled = "all";
            parameterTypes.enabled = true;
            propertyDeclarationTypes.enabled = true;
            variableTypes.enabled = true;
          };
        };
      };

      dprint = {
        command = lib.getExe pkgs.dprint;
        args = ["lsp"];
      };

      qmlls = {
        command = "${pkgs.qt6.qtdeclarative}/bin/qmlls";
        args = ["-E"];
      };

      pyright = {
        command = "${pkgs.pyright}/bin/pyright-langserver";
        args = ["--stdio"];
        config = {
          reportMissingTypeStubs = false;
          analysis = {
            typeCheckingMode = "basic";
            autoImportCompletions = true;
          };
        };
      };

      typescript-language-server = {
        command = lib.getExe pkgs.nodePackages.typescript-language-server;
        args = ["--stdio"];
        config = let
          inlayHints = {
            includeInlayEnumMemberValueHints = true;
            includeInlayFunctionLikeReturnTypeHints = true;
            includeInlayFunctionParameterTypeHints = true;
            includeInlayParameterNameHints = "all";
            includeInlayParameterNameHintsWhenArgumentMatchesName = true;
            includeInlayPropertyDeclarationTypeHints = true;
            includeInlayVariableTypeHints = true;
          };
        in {
          typescript-language-server.source = {
            addMissingImports.ts = true;
            fixAll.ts = true;
            organizeImports.ts = true;
            removeUnusedImports.ts = true;
            sortImports.ts = true;
          };

          typescript = {inherit inlayHints;};
          javascript = {inherit inlayHints;};

          hostInfo = "helix";
        };
      };

      vscode-css-language-server = {
        command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
        args = ["--stdio"];
        config = {
          provideFormatter = true;
          css.validate.enable = true;
          scss.validate.enable = true;
        };
      };
    };
  };
}
