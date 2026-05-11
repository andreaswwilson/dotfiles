local parsers = {
  'bash', 'c', 'diff', 'dockerfile', 'go', 'gomod', 'gowork', 'hcl',
  'html', 'javascript', 'json', 'json5', 'lua', 'markdown', 'markdown_inline',
  'python', 'query', 'regex', 'rust', 'terraform', 'toml', 'tsx',
  'typescript', 'vim', 'vimdoc', 'yaml',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',

    config = function()
      require('nvim-treesitter').install(parsers)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = parsers,
        callback = function() vim.treesitter.start() end,
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = parsers,
        callback = function()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  -- Show context of the current function
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    opts = { mode = 'cursor', max_lines = 3 },
  },
}
