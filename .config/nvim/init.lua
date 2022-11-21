vim.cmd([[
set tabstop=8
set softtabstop=0
set shiftwidth=4
set expandtab
set smarttab

set completeopt=menu,menuone,noselect

set whichwrap+=<,>,h,l,[,]
set nowrap
]])

local packer = require('packer')

packer.startup(function(use)
    use 'wbthomason/packer.nvim' -- Package manager
    use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
    use "fladson/vim-kitty"
    -- completion
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-emoji'
    use {
        'saecki/crates.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crates').setup()
        end,
    }
    -- snippets
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip' -- snippets in nvim-cmp
end)

local lspcfg = require("lspconfig")
local cmp = require("cmp")
local luasnip = require("luasnip")
local caps = require('cmp_nvim_lsp').default_capabilities()

lspcfg.sumneko_lua.setup{
    capabilities = caps
}

lspcfg.pylsp.setup{
    capabilities = caps
}

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true })
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "emoji" },
        { name = "crates" }
    }, {
        { name = "buffer" }
    })
})
