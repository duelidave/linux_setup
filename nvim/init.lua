-- Python3 config
--TODO: python3_host_prog = '~/.pyenv/shims/python'
vim.env.FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'
require('core')
require('plugins')
require('mymason')
-- require('lsp')
-- require('tree')
-- require('mycmp')
