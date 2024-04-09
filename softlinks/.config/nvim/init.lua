-- Quick iteration on nvim config, credit http://howivim.com/2016/damian-conway
vim.api.nvim_set_keymap('n', '<leader>v', ':edit $MYVIMRC<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>p', ':edit ' .. vim.fn.stdpath("data") .. '<CR>', {noremap = true, silent = true})

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

local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"
print('Plugin Directory: '.. pckr_path)
if not vim.loop.fs_stat(pckr_path) then
vim.fn.system({
    'git',
    'clone',
    "--filter=blob:none",
    'https://github.com/lewis6991/pckr.nvim',
    pckr_path
})
end
vim.opt.rtp:prepend(pckr_path)

require('pckr').add {
    'tpope/vim-abolish',               -- Word conversions, including snake to pascal case
    'tpope/vim-characterize',          -- UTF8 outputs for ga binding
    'tpope/vim-commentary',            -- Toggle comments on lines
    'tpope/vim-dadbod',                -- Database from your vim
    'tpope/vim-dispatch',              -- Builds and tests with asynchronous adapters: https://vimeo.com/63116209
    'tpope/vim-eunuch',                -- Utils and typing shebang line causes file type re-detection with +x
    'tpope/vim-jdaddy',                -- JSON text objects (aj) and pretty print (gqaj) for json
    'tpope/vim-obsession',             -- Makes sessions easier to manage with :Obsess
    'tpope/vim-rails',                 -- For rails codebases
    'tpope/vim-repeat',                -- Lets you use . for surround and other plugins
    'tpope/vim-rhubarb',               -- Github extension for fugitive
    'tpope/vim-sensible',              -- Good defaults, love your work tpope!
    'tpope/vim-speeddating',           -- <ctrl>a and <ctrl>x works on dates and roman numerals. 7<C-a> will jump a week.
    'tpope/vim-surround',              -- Delete, or insert around text objects
    'tpope/vim-unimpaired',            -- <3 pairings that marry ] and ['s REALLY GOOD, 5 stars
    'tpope/vim-vinegar',               -- Better file browser
    'dense-analysis/ale',              -- Linteger integration

    { 'tpope/vim-fugitive',
        config = function()
            vim.cmd [[
                " git status
                nnoremap gs :vertical Git<CR>
                " git blame
                nnoremap gb :Git blame<CR>
                " <C-l> refreshes git pane, like netrw refresh
                autocmd filetype fugitive nnoremap <buffer> <C-l> :Git<CR><C-l>
                " open github commands
                autocmd filetype fugitive nnoremap <buffer> gh<Space> :Git hub 
                " create empty commit, good for defining a plan
                autocmd filetype fugitive nnoremap <buffer> ce :Git commit --allow-empty<CR>
                " changes - quickfix jumplist of hunks since branching
                command! Changes exec ':Git difftool ' . systemlist('git merge-base origin/HEAD HEAD')[0]
                " edit commit template
                autocmd filetype fugitive nmap <buffer> ct :!cp ~/.git/message .git/message.bak<CR>
                                                         \ :!cp ~/.gitmessage .git/message<CR>
                                                         \ :!git config commit.template '.git/message'<CR>
                                                         \ :edit .git/message<CR>
                                                         \ Go<C-r>=GitHumans()<CR>
                                                         \ <ESC>gg
                " git log
                autocmd filetype fugitive nnoremap <buffer> gl :vert G log --oneline -100<CR>
                " <C-l> refreshes git pane, like netrw refresh
                autocmd filetype fugitive nnoremap <buffer> <C-l> :Git<CR><C-l>
                " open github commands
                autocmd filetype fugitive nnoremap <buffer> gh<Space> :Git hub 
                " create empty commit, good for 
                autocmd filetype fugitive nnoremap <buffer> ce :Git commit --allow-empty<CR>
            ]]
        end
    },

    { 'rose-pine/neovim',
        config = function()
            vim.cmd.colorscheme 'rose-pine'
        end
    }
}
