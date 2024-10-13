{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userModules.devtools.nixvim.plugins.lualine;
in {
  options = {
    userModules.devtools.nixvim.plugins.lualine.enable = mkEnableOption "Enables Lualine plugin for nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.lualine = {
      enable = true;
      theme = "gruvbox-material";
      globalstatus = true;

      sections = {
        lualine_a = ["mode"];
        lualine_b = ["branch"];
        lualine_c = ["filename" "diff"];

        lualine_x = [
          "diagnostics"

          # Show active language server
          {
            name.__raw = ''
              function()
                  local msg = ""
                  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                  local clients = vim.lsp.get_active_clients()
                  local non_null_ls_clients = {}

                  for _, client in ipairs(clients) do
                      if client.name ~= "null-ls" then
                          table.insert(non_null_ls_clients, client)
                      end
                  end

                  if #non_null_ls_clients > 0 then
                      for _, client in ipairs(non_null_ls_clients) do
                          local filetypes = client.config.filetypes
                          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                              return client.name
                          end
                      end
                  else
                      for _, client in ipairs(clients) do
                          if client.name == "null-ls" then
                              return client.name
                          end
                      end
                  end

                  return msg
              end
            '';
            icon = "";
            color.fg = "#A89984";
          }
          "fileformat"
          "filetype"
        ];
      };
    };
  };
}
