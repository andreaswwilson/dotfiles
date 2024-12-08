return
{
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-tree/nvim-web-devicons",
      "cljoly/telescope-repo.nvim",
    },
    cmd = "Telescope",
  },
  {
    "debugloop/telescope-undo.nvim",
    keys = {
      {
        "<leader>fu",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    },
    opts = {
      extensions = {
        undo = {
          -- telescope-undo.nvim config, see below
        },
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us. We won't use data, as everything is in it's own namespace (telescope
      -- defaults, as well as each extension).
      require("telescope").setup(opts)
      require("telescope").load_extension("undo")
    end,
  },
  {
    "cljoly/telescope-repo.nvim",
    keys = {
      { -- lazy style key map
        "<leader>fgg",
        "<cmd>Telescope repo list<cr>",
        desc = "git repo list",
      },
    },
    opts = {
      extensions = {
        repo = {
          list = {
            search_dirs = {
              "~/gitlab",
              "~/github",
              "~/dotfiles"
            },
          }
        },
        settings = {
          auto_lcd = true,
        },
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us. We won't use data, as everything is in it's own namespace (telescope
      -- defaults, as well as each extension).
      require("telescope").setup(opts)
      require("telescope").load_extension("repo")
    end,
  },
}
