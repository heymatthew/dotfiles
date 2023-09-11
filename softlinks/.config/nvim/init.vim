" .config/nvim/init.vim configuration file

" Personal shortcuts start with tab :)
let mapleader = "\<tab>"

"----------------------------------------
" Setting up Vundle, vim plugin manager
let plug_location=expand('~/.local/share/nvim/site/autoload/plug.vim')
if !filereadable(plug_location)
  echo "Installing plug"
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "Plug installed, reload?"
  finish " stop loading the rest of this script
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-surround'     " Delete, or insert around text objects
Plug 'tpope/vim-repeat'       " Lets you use . for surround and other plugins
Plug 'tpope/vim-commentary'   " Toggle comments on lines
Plug 'tpope/vim-unimpaired'   " <3 pairings that marry ] and ['s REALLY GOOD, 5 stars
Plug 'tpope/vim-fugitive'     " Git integration

augroup vim_fugitive
  " Quickfix window when shelling out to grep
  " Also works for git grep
  "   e.g. :Ggrep FIXME
  "   see https://github.com/tpope/vim-fugitive
  " autocmd QuickFixCmdPost *grep* cwindow
  " Also http://stackoverflow.com/a/39010855/81271
  " automatically open the location/quickfix window after :make, :grep, :lvimgrep and friends if there are valid locations/errors
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    cwindow

  vmap <C-f> y:silent   Ggrep "<C-r>0"<CR>zz
  nmap <C-f> yiw:silent Ggrep "<C-r>0"<CR>
augroup END

Plug 'bronson/vim-visual-star-search' " Vim multiline search

Plug 'hashivim/vim-terraform'
augroup terraform
  let g:terraform_align=1
  let g:terraform_fmt_on_save=0
augroup END

Plug 'michaeljsmith/vim-indent-object' " Select indents as an object

Plug 'vim-scripts/LargeFile' " turn off slow stuff in files > 20mb

Plug 'rose-pine/neovim' " colorscheme

" fzf fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/code/fzf', 'do': 'yes \| ./install' }
augroup fuzzy_finder
  " let g:jzf_history_dir = '~/.local/share/nvim/site/autoload/plug.vim'
  " let g:fzf_command_prefix = 'Fzf'
  nnoremap <leader>f :FZF<CR>
augroup END

Plug 'w0rp/ale'
augroup linting
  let g:ale_set_highlights = 0  " remove highlights
  let g:ale_set_loclist = 0     " prefer quickfix list to location list
  let g:ale_set_quickfix = 0
augroup END

" Plug 'neovim/nvim-lspconfig' " TODO Language Server Protocal auto config
" augroup lsp_config
"   " https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
" augroup END

Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
augroup golang
  let g:go_def_mode='gopls'  " Based on https://github.com/golang/tools/blob/master/gopls/doc/vim.md
  let g:go_info_mode='gopls'
augroup END

Plug 'junegunn/goyo.vim'  " Distraction free writing in vim
augroup prose
  nnoremap <leader>p :call Prose()<CR>
  function! Prose()
    " word wrap visually and no newlines unless explicit
    set wrap linebreak nolist textwidth=0 wrapmargin=0
    set spell
    exec("Goyo")
  endfunction
augroup END

Plug 'scrooloose/nerdtree'
augroup file_browser
  let NERDTreeShowLineNumbers = 1  " Make nerdtree honor numbers
  let NERDTreeShowHidden = 1       " Show dotfiles
augroup END

" TODO substitute nerdtree, https://github.com/kyazdani42/nvim-tree.lua
" Plug 'kyazdani42/nvim-tree.lua'

" Plug 'kyazdani42/nvim-tree.lua'     " File browser
" Plug 'kyazdani42/nvim-web-devicons' " icons for file browser
" lua << EOF
" require("nvim-tree").setup({
"   sort_by = "case_sensitive",
"   view = {
"     adaptive_size = true,
"     mappings = {
"       list = {
"         { key = "u", action = "dir_up" },
"       },
"     },
"   },
"   renderer = {
"     group_empty = true,
"   },
"   filters = {
"     dotfiles = true,
"   },
" })
" EOF

Plug 'lifepillar/vim-solarized8'

call plug#end()

syntax off                       " case against... https://www.linusakesson.net/programming/syntaxhighlighting/
set termguicolors                " enable true colors support
set guifont=mplus-1m-regular:h12 " from system_profiler SPFontsDataType

" <3
" from https://github.com/rose-pine/neovim
colorscheme rose-pine
set background=light
lua << EOF
require('rose-pine').setup({
	--- @usage 'main' | 'moon'
	dark_variant = 'moon',
})
vim.cmd('colorscheme rose-pine')
EOF

if filereadable($HOME . "/.config/iterm_theme")
  let lines = readfile($HOME . "/.config/iterm_theme")
  " 'dark' or 'light'
  let iterm_theme = lines[0]
  exe "set background=" . iterm_theme
endif

" set relativenumber        " better navigation, disabled for pairing
set number                " give line number that you're on
set scrolloff=5           " when scrolling, keep cursor 5 lines away from border
set foldmethod=manual     " fold by paragraph or whatever you feel is appropriate
" set textwidth=100         " Automatically insert newlines
" set colorcolumn=100       " Show 100th char visually
set nojoinspaces          " Single space after period when using J
set hlsearch              " Highlight my searches :)
set ignorecase            " Search case insensitive...
set smartcase             " ... but not it begins with upper case
set incsearch             " Shows the match while typing
set magic                 " Allows pattern matching with special characters
set spl=en spell          " Use English for spellchecking,
set nospell               " Spellcheck is off initially
set autoindent            " indent on newlines
set smartindent           " recognise syntax of files
set noswapfile            " Don't use swapfile
set nobackup              " Don't create annoying backup files
set mouse=a               " Let vim use the mouse, grab and pull splits around etc.

" set foldminlines=10       " Smaller than this will always show like it was open
" set clipboard=unnamedplus " yank and put straight to system clipboard

" See https://unix.stackexchange.com/a/383044
" When someone modifies a file externally, autoread it back in
set autoread
au CursorHold,CursorHoldI * checktime

" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
  \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

iabbrev waht what
iabbrev tehn then
iabbrev teh the
iabbrev hte the
iabbrev functino function
iabbrev iamge image
iabbrev wehn when

" Search and page mappings: center cursor when jumping in search
nnoremap N Nzz
nnoremap n nzz
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Whitespace management
set                                expandtab   tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype markdown setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype go       setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype perl     setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype ruby     setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype sh       setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4

highlight TrailingWhitespace ctermbg=grey guibg=grey
match TrailingWhitespace /\s\+$/

" JS require doesn't always include extension, auto add this for gf
" https://medium.com/usevim/vim-101-jumping-between-files-f9e16f79f63a
autocmd Filetype javascript setlocal suffixesadd+=.js

" Navigatoin
nnoremap H <C-o> " Browse code like you're using vimium back button
nnoremap L <C-i> " Browse code like you're using vimium forward button

" Navigate splits more naturally with Ctrl + hjkl
nnoremap <C-h> 0<C-w>h
nnoremap <C-l> 0<C-w>l
nnoremap <C-j> 0<C-w>j
nnoremap <C-k> 0<C-w>k

" FIXME G grep and Ggrep have differing behavour
" G grep won't open in the quickfix pane, so I'm going with Ggrep
vmap <C-f> y:lclose<CR>:silent Ggrep -I "<C-r>0"<CR>zz
nmap <C-f> yiW:silent Ggrep -I "<C-r>0"<CR>zz<CR>

" Shared data across nvim sessions
" '500  : save last 500 files local marks [a-z]
" f1    : also store global marks [A-Z0-9]
" <500  : store only 500 lines of registers
set shada='500,f1
" SHADA EXCEPTION, cursor placement at top on git commit
autocmd BufReadPost COMMIT_EDITMSG exe "normal! gg"

" Quickly open, reload and edit rc files
nnoremap <leader>vv :e $MYVIMRC<CR>
nnoremap <leader>vu :source $MYVIMRC<CR>:PlugUpdate<CR>:source $MYVIMRC<CR>:GoInstallBinaries<CR>
nnoremap <leader>vr :source $MYVIMRC<CR>
nnoremap <leader>zz :e $HOME/.zshrc<CR>
nnoremap <leader>zl :e $HOME/.zshrc.local<CR>

" vp doesn't replace paste buffer
" credit https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/#prevent-replacing-paste-buffer-on-paste
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

function! UpdateEverything()
  exe('source ' . $MYVIMRC)
  exe('PlugUpdate')
  exe('source ' . $MYVIMRC)
  exe('GoInstallBinaries')
endfunction

" Syntax highlighting is often not quite right.
nnoremap <leader>t :set filetype=

" turn off EX mode (it annoys me, I don't use it)
":map Q <Nop>
" More usefully, reformat paragraphs with vim rules
" - http://alols.github.io/2012/11/07/writing-prose-with-vim
" - https://github.com/reedes/vim-pencil
map Q gqap

" Display line numbers in help
autocmd FileType help setlocal number relativenumber

" Vertical split for help files
autocmd FileType help wincmd L

" Copy current file to clipboard and yank buffers
nnoremap <leader>cf :let @*=expand("%")<CR>:let @0=expand("%")<CR>

" Triage stuff: Quickly cycle between contexts
nnoremap <leader><leader> :tab split<cr>
nnoremap <backspace><backspace> :tabclose<cr>

" Quickly split current view
nmap <leader>y 0:lclose<CR>:cclose<CR>:split<CR>
nmap <leader>x 0:lclose<CR>:cclose<CR>:vsplit<CR>
nmap <leader>n 0:rightbelow vnew<CR>
set splitright               " Split vertical windows right to the current windows
set splitbelow               " Split horizontal windows below to the current windows

" Open current focused file in new tab
nnoremap <leader><leader> :tab split<CR>
nnoremap <leader>q <C-w>q

" Set title on terminal to focused buffer filename
auto BufEnter * :set title | let &titlestring = 'v:' . expand('%')
"
" w!! saves as sudo
cmap w!! w !sudo tee > /dev/null %

" from https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
" Open file browser in the directory of the current file
nnoremap <space><space> :edit %:p:h<CR>

" Open git status
nnoremap <leader>g :Git<CR>

" jj is like escape
inoremap jj <ESC>

" Double Escape and jj leave insert mode in terminal
tnoremap <ESC><ESC> <C-\><C-N>

" Ctrl + w actions in terminal windows
tnoremap <C-w> <C-\><C-N><C-w>

" Terminal enters insert mode automatically
autocmd TermOpen,BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave                      term://* stopinsert
autocmd TermOpen * setlocal statusline=%{b:term_title}

" dictionary lookup for words, depends on 'dict'
" https://vim.fandom.com/wiki/Lookup_word_in_dict
nnoremap <leader>l mayiw`a:exe "!dict -P - $(echo " . @" . ")"<CR>
vnoremap <leader>l may`a:exe "!dict -P - $(echo " . @" . ")"<CR>

" Git commit messages lint similar to hemingway app
" See https://github.com/btford/write-good
" Based on https://github.com/dense-analysis/ale/blob/master/ale_linters/markdown/writegood.vim
call ale#handlers#writegood#DefineLinter('gitcommit')
