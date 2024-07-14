return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Header
		local logo = [[
 ▄████▄   ███▄    █  ██▓▒██   ██▒ ██▒   █▓ ██▓ ███▄ ▄███▓
▒██▀ ▀█   ██ ▀█   █ ▓██▒▒▒ █ █ ▒░▓██░   █▒▓██▒▓██▒▀█▀ ██▒
▒▓█    ▄ ▓██  ▀█ ██▒▒██▒░░  █   ░ ▓██  █▒░▒██▒▓██    ▓██░
▒▓▓▄ ▄██▒▓██▒  ▐▌██▒░██░ ░ █ █ ▒   ▒██ █░░░██░▒██    ▒██ 
▒ ▓███▀ ░▒██░   ▓██░░██░▒██▒ ▒██▒   ▒▀█░  ░██░▒██▒   ░██▒
░ ░▒ ▒  ░░ ▒░   ▒ ▒ ░▓  ▒▒ ░ ░▓ ░   ░ ▐░  ░▓  ░ ▒░   ░  ░
  ░  ▒   ░ ░░   ░ ▒░ ▒ ░░░   ░▒ ░   ░ ░░   ▒ ░░  ░      ░
░           ░   ░ ░  ▒ ░ ░    ░       ░░   ▒ ░░      ░   
░ ░               ░  ░   ░    ░        ░   ░         ░   
░                                     ░                  
]]
		dashboard.section.header.val = vim.split(logo, "\n")

		-- Buttons
		dashboard.section.buttons.val = {
			dashboard.button("n", " " .. " New file", "<cmd> ene <BAR> startinsert <cr>"),
			dashboard.button("f", " " .. " Find file", "<cmd> Telescope find_files <cr>"),
			dashboard.button("g", " " .. " Live grep", "<cmd> Telescope live_grep <cr>"),
			dashboard.button("r", " " .. " Recent files", "<cmd> Telescope oldfiles <cr>"),
			-- dashboard.button('s', ' ' .. ' Restore Session', "<cmd>lua require('persistence').load()<cr>"),
			dashboard.button("s", " " .. " Restore Session", "<cmd>SessionLoad<cr>"),
			dashboard.button("l", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"),
			dashboard.button("h", "󱙤 " .. " Check Health", "<cmd>checkhealth<cr>"),
			dashboard.button("q", " " .. " Quit", "<cmd> qa <cr>"),
		}
		for _, button in ipairs(dashboard.section.buttons) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
		end
		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.section.footer.opts.hl = "AlphaFooter"
		dashboard.opts.layout[1].val = 8

		-- Footer (Lazy statistics)
		vim.api.nvim_create_autocmd("User", {
			callback = function()
				local stats = require("lazy").stats()
				local ms = math.floor(stats.startuptime * 100) / 100
				dashboard.section.footer.val = "󱐌 Lazy-loaded "
					.. stats.loaded
					.. "/"
					.. stats.count
					.. " plugins in "
					.. ms
					.. "ms"
				pcall(vim.cmd.AlphaRedraw)
			end,
		})

		-- -- Fortune
		-- local fortune = ""
		-- if vim.fn.executable "fortune" == 1 then
		--   local handle = io.popen "fortune"
		--   if handle ~= nil then
		--     fortune = handle:read "*a"
		--     handle:close()
		--   end
		-- end
		-- local buttons = {
		--   type = "group",
		--   val = {
		--     { type = "padding", val = 2 },
		--     { type = "text", val = fortune, opts = { position = "center" } },
		--     { type = "padding", val = 2 },
		--   },
		--   position = "center",
		-- }
		-- dashboard.opts.layout[6] = buttons

		dashboard.config.opts.noautocmd = true
		alpha.setup(dashboard.config)
	end,
}
