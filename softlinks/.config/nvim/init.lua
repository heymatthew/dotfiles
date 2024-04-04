-- Quick iteration on nvim config, credit http://howivim.com/2016/damian-conway
vim.keymap.set('n', '<leader>v', ':edit $MYVIMRC<CR>', { noremap = true, silent = true })
vim.cmd "autocmd BufWritePost $MYVIMRC source $MYVIMRC"
