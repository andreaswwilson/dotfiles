return {
	"numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},

	config = function()
		local comment = require("Comment")
		comment.setup({})
	end,
}
