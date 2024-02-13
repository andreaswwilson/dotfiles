return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = { "VeryLazy" },
	config = function()
		local lualine = require("lualine")
		lualine.setup({
			sections = {
				lualine_c = {
					-- { require("NeoComposer.ui").status_recording },
					{
						"filename",
						file_status = true,
						newfile_status = true,
						symbols = {
							modified = "[+]", -- Text to show when the file is modified.
							readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
							unnamed = "[UNNAMED]", -- Text to show for unnamed buffers.
							newfile = "[New]",
						},
						path = 1,
					},
					{
						"diagnostic-message",
						icons = {
							error = " ",
							warn = " ",
							hint = " ",
							info = " ",
						},
					},
				},
			},
		})
	end,
}
