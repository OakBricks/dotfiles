local packer = require('packer')

packer.startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager
  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
  use "fladson/vim-kitty"
end)

local lspcfg = require("lspconfig")

lspcfg.sumneko_lua.setup{}

lspcfg.pylsp.setup{}


