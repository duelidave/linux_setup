-- Python3 config
--TODO: python3_host_prog = '~/.pyenv/shims/python'
vim.env.FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'

-- nvm-node in PATH eintragen (mason spawnt Prozesse ohne Shell-Aliases)
local nvm_bins = vim.fn.glob(vim.fn.expand("~/.nvm/versions/node/*/bin"), false, true)
if #nvm_bins > 0 then
    vim.env.PATH = nvm_bins[1] .. ":" .. vim.env.PATH
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('core')
require('lazy').setup('plugins', { ui = { border = "rounded" } })
require('mymason')
