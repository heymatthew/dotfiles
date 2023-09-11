" .vimrc configuration file

let mapleader = "\<tab>"

let plug_executable=expand('~/.vim/autoload/plug.vim')
if !filereadable(plug_executable)
    echo "Installing plug"
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

let plug_dir = '~/.vim/plugged'

call plug#begin(plug_dir)
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
Plug 'tpope/vim-abolish'               " Word conversions, including snake to pascal case
Plug 'bronson/vim-visual-star-search'  " Vim multiline search
Plug 'michaeljsmith/vim-indent-object' " Select indents as an object
Plug 'fatih/vim-go',  { 'do': ':GoInstallBinaries' }
Plug 'w0rp/ale',      { 'as': 'vim-ale' }
Plug 'junegunn/fzf',  { 'as': 'vim-fzf', 'dir': '~/code/fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'                " Defaults
let g:fzf_preview_window = ['right,50%', 'ctrl-/']
Plug 'heymatthew/vim-blinkenlights'
Plug 'junegunn/vader.vim'              " Vimscript test framework
Plug 'junegunn/vim-easy-align'         " Align paragraph = with gaip=
Plug 'vim-scripts/SyntaxAttr.vim'      " Display syntax highlighting attributes under cursor
call plug#end()

nnoremap <F2> :call SyntaxAttr()<CR>
nnoremap <backspace> :noh<CR>

" Dark mode isn't as good for your eyes as you believe
" https://www.wired.co.uk/article/dark-mode-chrome-android-ios-science
" FIXME: Extract to function, detect system
let style = system('defaults read -g AppleInterfaceStyle 2> /dev/null')
if style =~ '\cdark'
  set background=dark
else
  set background=light
endif

colorscheme blinkenlights
set colorcolumn=120

nnoremap <leader>f :FZF<CR>

augroup vim_fugitive # for tpope/vim-fugitive
  " automatically open the location/quickfix window after :make, :grep, :lvimgrep and friends if there are valid locations/errors
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    cwindow

  vmap <C-f> y:silent   Ggrep "<C-r>0"<CR>zz
  nmap <C-f> yiw:silent Ggrep "<C-r>0"<CR>

  " Git status
  nnoremap <leader>g :G<CR>
  nnoremap <leader>l :G log --oneline --reverse origin/HEAD...<CR>
  nnoremap <leader>r :G rebase --interactive origin/HEAD<CR>

  " Show diffs since master in quickfix list
  command Gchanges echo "deprecated, use :Changes"
  command Changes :G difftool origin/HEAD

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
" nmemonic s = split new, tab, quit, x, y
nmap <leader>y 0:lclose<CR>:cclose<CR>:split<CR>
nmap <leader>x 0:lclose<CR>:cclose<CR>:vsplit<CR>
nmap <leader>n 0:rightbelow vnew<CR>
set splitright               " Split vertical windows right to the current windows
set splitbelow               " Split horizontal windows below to the current windows
nnoremap <leader>t :tab split<cr>
nnoremap <leader>q :tabclose<cr>

" Vertical split for help files
autocmd FileType help wincmd L

" Triage stuff: Quickly cycle between contexts
nnoremap <leader><leader> :tab split<cr>
nnoremap <leader><backspace> :tabclose<cr>
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

" Reload vimrc on edits
" credit http://howivim.com/2016/damian-conway
autocmd! BufWritePost $MYVIMRC source $MYVIMRC
autocmd! BufWritePost ~/.vim/plugged/**/* nested source $MYVIMRC

" Whitespace management
set                                 expandtab   tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype markdown  setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype go        setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype perl      setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype ruby      setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype sh        setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype julia     setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype gitconfig setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4

" from https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
" Open file browser in the directory of the current file
" nnoremap <space><space> :edit %:p:h<CR>

" Switch between the last two files
nnoremap <space><space> <C-^>

" Quick access to clipboard, e.g. <space>p or <space>yy
nnoremap <space> "+
vnoremap <space> "+

set number                 " give line number that you're on
set scrolloff=5            " when scrolling, keep cursor 5 lines away from border
set foldmethod=indent      " Indent fold
set foldlevelstart=5       " Most folds open
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
set belloff=all            " I find terminal bells irritating
set mouse=a                " Looks like this is part of neovim defaults
set shortmess-=S           " show search matches, see https://stackoverflow.com/a/4671112

" set relativenumber        " toggle with yor, off by default
" set textwidth=100         " Automatically insert newlines
" set colorcolumn=100       " Show 100th char visually

function! ProjectVimrcPath()
  let root = system('git rev-parse --show-toplevel 2> /dev/null')
  if v:shell_error
    return ''
  endif
  let root = substitute(root, '\n$', '', '')
  return root . '/.git/vimrc'
endfunction

function! EditProjectVimrc()
  let vimrc = ProjectVimrcPath()
  exec 'edit ' . vimrc
endfunction

let project_vimrc = ProjectVimrcPath()
if exists(project_vimrc) && filereadable(project_vimrc)
  exec 'source ' . project_vimrc
endif

" Quickly open, reload and edit rc files
nnoremap <leader>vv :e $MYVIMRC<CR>
nnoremap <leader>vu :source $MYVIMRC<CR>:PlugUpdate<CR>:source $MYVIMRC<CR>:GoInstallBinaries<CR>
nnoremap <leader>vr :source $MYVIMRC<CR>
nnoremap <leader>zz :e $HOME/.zshrc<CR>
nnoremap <leader>zl :e $HOME/.zshrc.local<CR>
nnoremap <leader>vp :exec 'edit ' . project_vimrc<CR>
nnoremap <leader>ve :exec 'edit ' . plug_dir<CR>
nnoremap <leader>vc :exec 'edit ' . plug_dir . '/vim-blinkenlights/colors/blinkenlights.vim'<CR>

" Reverse search command history
nnoremap <leader>c q:?

" Vim autojump to last position VIM was at when opening a file.
" See --> http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
"
" Tell vim to remember certain things when we exit
" '10  :  marks will be remembered for up to 10 previously edited files
" "100 :  will save up to 100 lines for each register
" :5000:  up to 5000 lines of command-line history will be remembered
" %    :  saves and restores the buffer list
" n... :  where to save the viminfo files
set viminfo='10,\"100,:5000,n~/.vim/info

" Disable modelines as a security precaution
" from https://github.com/thoughtbot/dotfiles/blob/main/vimrc
set nomodeline modelines=0

" visual paste doesn't clobber what you've got in the paste buffer
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

" Insert timestamps after cursor
command! Now normal! a<C-r>=strftime('%Y-%m-%dT%T%z')<CR>
command! Today normal! a<C-r>=strftime('%Y-%m-%dT%T%z')<CR>
