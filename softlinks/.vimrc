" .vimrc configuration file

let mapleader = "\<tab>"

let plug_executable=expand('~/.vim/autoload/plug.vim')
if !filereadable(plug_executable)
    echo "Installing plug"
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'              " Good defaults, love your work tpope!
Plug 'tpope/vim-characterize'          " UTF8 outputs for ga binding
Plug 'tpope/vim-commentary'            " Toggle comments on lines
Plug 'tpope/vim-dadbod'                " Database from your vim
Plug 'tpope/vim-rails'                 " For rails codebases
Plug 'tpope/vim-repeat'                " Lets you use . for surround and other plugins
Plug 'tpope/vim-speeddating'           " <ctrl>a and <ctrl>x works on dates and roman numerals. 7<C-a> will jump a week.
Plug 'tpope/vim-surround'              " Delete, or insert around text objects
Plug 'tpope/vim-unimpaired'            " <3 pairings that marry ] and ['s REALLY GOOD, 5 stars
Plug 'tpope/vim-vinegar'               " Better file browser
Plug 'tpope/vim-fugitive'              " Git
Plug 'bronson/vim-visual-star-search'  " Vim multiline search
Plug 'michaeljsmith/vim-indent-object'  " Select indents as an object
Plug 'fatih/vim-go',  { 'do': ':GoInstallBinaries' }
Plug 'w0rp/ale',      { 'as': 'vim-ale' }
Plug 'junegunn/fzf',  { 'as': 'vim-fzf', 'dir': '~/code/fzf', 'do': 'yes \| ./install' }
call plug#end()

nnoremap <leader>f :FZF<CR>

augroup vim_fugitive # for tpope/vim-fugitive
  " automatically open the location/quickfix window after :make, :grep, :lvimgrep and friends if there are valid locations/errors
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    cwindow

  vmap <C-f> y:silent   Ggrep "<C-r>0"<CR>zz
  nmap <C-f> yiw:silent Ggrep "<C-r>0"<CR>

  " Git status
  nnoremap <leader>g :Git<CR>

  " Show diffs since master in quickfix list
  command Gchanges :G difftool origin/HEAD

  " Always use vertical diffs
  set diffopt+=vertical
augroup END

augroup ale # for w0rp/ale
  let g:ale_set_highlights = 0               " remove highlights
  let g:ale_set_loclist = 0                  " don't clobber location list
  let g:ale_set_quickfix = 0                 " don't clobber quickfix list
  let g:ale_virtualtext_cursor = 'current'   " only show hints under cursor

  " Move between linting errors
  nnoremap ]r :ALENextWrap<CR>
  nnoremap [r :ALEPreviousWrap<CR>
augroup END

augroup fzf # for junegunn/fzf
  nnoremap <leader>f :FZF<CR>
augroup END

" Quickly split current view
nmap <leader>y 0:lclose<CR>:cclose<CR>:split<CR>
nmap <leader>x 0:lclose<CR>:cclose<CR>:vsplit<CR>
nmap <leader>n 0:rightbelow vnew<CR>
set splitright               " Split vertical windows right to the current windows
set splitbelow               " Split horizontal windows below to the current windows

" Vertical split for help files
autocmd FileType help wincmd L

" Triage stuff: Quickly cycle between contexts
nnoremap <leader><leader> :tab split<cr>
nnoremap <backspace><backspace> :tabclose<cr>
nnoremap <leader>q <C-w>q

" Show line numbers in files, help, and netrw
set number
autocmd FileType help setlocal number
let g:netrw_bufsettings = 'number'

" Copy current file to clipboard and yank buffers
nnoremap <leader>cf :let @*=expand("%")<CR>:let @0=expand("%")<CR>

" Window resize events make splits equal
" https://hachyderm.io/@tpope/109784416506853805
autocmd VimResized * wincmd =

" Whitespace management
set                                 expandtab   tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype markdown  setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype go        setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype perl      setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype ruby      setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype sh        setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype julia     setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype gitconfig setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
highlight TrailingWhitespace ctermbg=grey guibg=grey
match TrailingWhitespace /\s\+$/

" from https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
" Open file browser in the directory of the current file
" nnoremap <space><space> :edit %:p:h<CR>

" Switch between the last two files
nnoremap <space><space> <C-^>

set number                 " give line number that you're on
set scrolloff=5            " when scrolling, keep cursor 5 lines away from border
set foldmethod=manual      " fold by paragraph or whatever you feel is appropriate
set nojoinspaces           " Single space after period when using J
set hlsearch               " Highlight my searches :)
set ignorecase             " Search case insensitive...
set smartcase              " ... but not it begins with upper case
set incsearch              " Shows the match while typing
set magic                  " Allows pattern matching with special characters
set autoindent             " indent on newlines
set smartindent            " recognise syntax of files
set noswapfile             " Don't use swapfile
set nobackup               " Don't create annoying backup files
set wrap linebreak nolist  " wrap words, incompatable with visible whitespace (list and listchars)
set showcmd                " show command on bottom right as it's typed

" set mouse=a               " Looks like this is part of neovim defaults
" set relativenumber        " toggle with yor, off by default
" set textwidth=100         " Automatically insert newlines
" set colorcolumn=100       " Show 100th char visually

" Quickly open, reload and edit rc files
nnoremap <leader>vv :e $MYVIMRC<CR>
nnoremap <leader>vu :source $MYVIMRC<CR>:PlugUpdate<CR>:source $MYVIMRC<CR>:GoInstallBinaries<CR>
nnoremap <leader>vr :source $MYVIMRC<CR>
nnoremap <leader>zz :e $HOME/.zshrc<CR>
nnoremap <leader>zl :e $HOME/.zshrc.local<CR>

" Reverse search command history
nnoremap <leader>c q:?
