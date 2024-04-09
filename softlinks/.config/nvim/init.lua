-- Quick iteration on nvim config, credit http://howivim.com/2016/damian-conway
vim.api.nvim_set_keymap('n', '<leader>v', ':edit $MYVIMRC<CR>', {noremap = true, silent = true})
vim.cmd 'autocmd! BufWritePost $MYVIMRC source $MYVIMRC'

function indent_opts(args)
    vim.api.nvim_create_autocmd('FileType', {
        pattern = args.file_type,
        callback = function()
            vim.api.nvim_buf_set_option(0, 'expandtab', args.expand_tab or true)
            vim.api.nvim_buf_set_option(0, 'tabstop', args.indent)
            vim.api.nvim_buf_set_option(0, 'softtabstop', args.indent)
            vim.api.nvim_buf_set_option(0, 'shiftwidth', args.indent)
        end
    })
end

indent_opts({ file_type = 'markdown', indent = 2 })
indent_opts({ file_type = 'go', indent = 4, expand_tab = false })
indent_opts({ file_type = 'perl', indent = 4 })
indent_opts({ file_type = 'ruby', indent = 2 })
indent_opts({ file_type = 'sh', indent = 4 })
indent_opts({ file_type = 'julia', indent = 4 })
indent_opts({ file_type = 'gitconfig', indent = 4, expand_tab = false })
indent_opts({ file_type = 'lua', indent = 4 })

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
print("Plugins: " .. lazy_path)
if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazy_path,
    })
end
vim.opt.rtp:prepend(lazy_path)
