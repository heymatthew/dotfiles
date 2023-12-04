" .vimrc configuration file

let mapleader = "\<tab>"

let plug_executable=expand('~/.vim/autoload/plug.vim')
if !filereadable(plug_executable)
    echo "Installing plug"
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

let plug_dir = '~/.vim/plugged'

call plug#begin(plug_dir)
Plug 'tpope/vim-abolish'               " Word conversions, including snake to pascal case
Plug 'tpope/vim-characterize'          " UTF8 outputs for ga binding
Plug 'tpope/vim-commentary'            " Toggle comments on lines
Plug 'tpope/vim-dadbod'                " Database from your vim
Plug 'tpope/vim-fugitive'              " Git
Plug 'tpope/vim-rails'                 " For rails codebases
Plug 'tpope/vim-repeat'                " Lets you use . for surround and other plugins
Plug 'tpope/vim-rhubarb'               " Github extension for fugitive
Plug 'tpope/vim-sensible'              " Good defaults, love your work tpope!
Plug 'tpope/vim-speeddating'           " <ctrl>a and <ctrl>x works on dates and roman numerals. 7<C-a> will jump a week.
Plug 'tpope/vim-surround'              " Delete, or insert around text objects
Plug 'tpope/vim-unimpaired'            " <3 pairings that marry ] and ['s REALLY GOOD, 5 stars
Plug 'tpope/vim-vinegar'               " Better file browser
Plug 'bronson/vim-visual-star-search'  " Vim multiline search
Plug 'michaeljsmith/vim-indent-object' " Select indents as an object
Plug 'fatih/vim-go',  { 'do': ':GoInstallBinaries' }
Plug 'w0rp/ale',      { 'as': 'vim-ale' }
Plug 'junegunn/fzf',  { 'as': 'vim-fzf', 'dir': '~/code/fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'                " Defaults
Plug 'junegunn/gv.vim'                 " git graph with :GV, :GV!, :GV?
let g:fzf_preview_window = ['right,50%', 'ctrl-/']
Plug 'junegunn/goyo.vim'               " Distraction free writing in vim
Plug 'heymatthew/vim-blinkenlights'
Plug 'junegunn/vader.vim'              " Vimscript test framework
Plug 'junegunn/vim-easy-align'         " Align paragraph = with gaip=
Plug 'vim-scripts/SyntaxAttr.vim'      " Display syntax highlighting attributes under cursor
Plug 'roman/golden-ratio'              " Splits follow golden ratio rules
call plug#end()

nnoremap <F2> :call SyntaxAttr()<CR>

" Hide search results
nnoremap <BACKSPACE> :noh<CR>

" Switch to the file you just had open
nnoremap <SPACE> <C-^>

" Dark mode isn't as good for your eyes as you believe
" https://www.wired.co.uk/article/dark-mode-chrome-android-ios-science
" FIXME: Extract to function, detect system
if !empty($LC_APPEARANCE)
  exec 'set background=' . $LC_APPEARANCE
endif

colorscheme blinkenlights
set colorcolumn=120

nnoremap <leader>f :FZF<CR>
nnoremap <leader>t :set filetype=

augroup vim_fugitive " for tpope/vim-fugitive
  " automatically open the location/quickfix window after :make, :grep, :lvimgrep and friends if there are valid locations/errors
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    cwindow

  vmap <C-f> y:silent   Ggrep "<C-r>0"<CR>zz
  nmap <C-f> yiw:silent Ggrep "<C-r>0"<CR>

  " Git status
  nnoremap <leader>g :G<CR>
  nnoremap <leader>l :G log --oneline origin/HEAD..<CR>
  nnoremap <leader>r :G rebase --interactive origin/HEAD<CR>

  " Show diffs since master in quickfix list
  command Changes exec ':G difftool ' . systemlist('git merge-base origin/HEAD HEAD')[0]

  " Always use vertical diffs
  set diffopt+=vertical
augroup END

augroup ale " for w0rp/ale
  let g:ale_set_highlights = 0               " remove highlights
  let g:ale_set_loclist = 0                  " don't clobber location list
  let g:ale_set_quickfix = 0                 " don't clobber quickfix list
  let g:ale_virtualtext_cursor = 'disabled'  " don't show virtual text with errors

  " Move between linting errors
  nnoremap ]r :ALENextWrap<CR>
  nnoremap [r :ALEPreviousWrap<CR>
augroup END

augroup fzf " for junegunn/fzf
  nnoremap <leader>f :FZF<CR>
augroup END

augroup easy_align " for junegunn/vim-easy-align
  " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
  vmap <Enter> <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
augroup END

" Move default where splits open
set splitright               " Split vertical windows right to the current windows
set splitbelow               " Split horizontal windows below to the current windows
" Vertical split for help files
autocmd FileType help wincmd L

" Quickly close open window
nnoremap <leader>q :bd<CR>

" Show line numbers in files, help, and netrw
set number
autocmd FileType help setlocal number
let g:netrw_bufsettings = 'number'

" Using n and p in search centers the window
nnoremap n nzz
nnoremap p pzz

" Copy current file to clipboard and yank buffers
nnoremap <leader>cf :let @*=expand("%")<CR>:let @0=expand("%")<CR>

" Window resize events make splits equal
" https://hachyderm.io/@tpope/109784416506853805
autocmd VimResized * wincmd =
" ...and new splits that might open, e.g. v from netrw
let s:resize_exceptions = ['qf', 'loc', 'fugitive']
autocmd WinNew * if index(s:resize_exceptions, &ft) == -1 | wincmd = | endif
" GoldenRatio mnemonic, <C-w>- is like <C-w>=
let g:golden_ratio_autocommand = 0
nnoremap <silent> <C-w>- :GoldenRatioResize<CR>

" Reload vimrc on edits
" credit http://howivim.com/2016/damian-conway
autocmd! BufWritePost $MYVIMRC source $MYVIMRC
autocmd! BufWritePost $HOME/dotfiles/softlinks/.vimrc source $MYVIMRC
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

" Filetype detection
autocmd BufNewFile,BufRead .env* setlocal filetype=sh

" Debugging
autocmd FileType ruby :iabbrev <buffer> puts puts # FIXME: commit = death<ESC>F#<LEFT>i
autocmd FileType ruby :iabbrev <buffer> binding binding # FIXME: commit = death<ESC>F#<LEFT>i

" Quick access to clipboard, e.g. <leader>p or <leader>yy
nnoremap <leader> "+
vnoremap <leader> "+

set scrolloff=5            " 5 lines always visible at top and bottom
set sidescrolloff=5        " 5 characters always visible left and right when scrollwrap is set
set nojoinspaces           " Single space after period when using J
set hlsearch               " Highlight my searches :)
set ignorecase             " Search case insensitive...
set smartcase              " ... but not it begins with upper case
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

" set textwidth=100         " Automatically insert newlines
" set colorcolumn=100       " Show 100th char visually

" Indent fold, but expand all folds when opening a file
set foldmethod=syntax
autocmd BufRead * normal zR
autocmd Filetype fugitive setlocal foldmethod=manual
autocmd Filetype haml     setlocal foldmethod=indent

" Quickly open, reload and edit rc files
nnoremap <leader>vv :e $HOME/dotfiles/softlinks/.vimrc<CR>
nnoremap <leader>vu :source $MYVIMRC<CR>:PlugUpdate<CR>:source $MYVIMRC<CR>:GoInstallBinaries<CR>
nnoremap <leader>vr :source $MYVIMRC<CR>
nnoremap <leader>zz :e $HOME/dotfiles/softlinks/.zshrc<CR>
nnoremap <leader>zl :e $HOME/.zshrc.local<CR>
nnoremap <leader>vp :exec 'edit ' . plug_dir<CR>
nnoremap <leader>vc :exec 'edit ' . plug_dir . '/vim-blinkenlights/colors/blinkenlights.vim'<CR>
nnoremap <leader>m :e $HOME/monologue.md<CR>

" Spelling
autocmd Filetype gitcommit setlocal spell
autocmd Filetype markdown  setlocal spell

" Reverse search command history
nnoremap <leader>c q:?

" Vim autojump to last position VIM was at when opening a file.
" See --> http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
"
" Tell vim to remember certain things when we exit
" '200  : marks will be remembered for up to 200 previously edited files
" "100 :  will save up to 100 lines for each register
" :5000:  up to 5000 lines of command-line history will be remembered
" %    :  saves and restores the buffer list
" n... :  where to save the viminfo files
set viminfo='200,\"100,:5000,n~/.vim/info

" See https://vim.fandom.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
let s:cursor_exceptions = ['qf', 'loc', 'fugitive', 'gitcommit', 'gitrebase']
function! PositionCursor()
  if index(s:cursor_exceptions, &ft) == -1 && line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction
autocmd BufWinEnter * call PositionCursor()

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
  return "p@=RestoreRegister()\<CR>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" Insert timestamps after cursor
command! Now normal! a<C-r>=strftime('%Y-%m-%dT%T%z')<CR>
command! Today normal! a<C-r>=strftime('%Y-%m-%d')<CR>
inoremap <C-t> <C-r>=strftime('%Y-%m-%dT%T%z')<CR>
inoremap <C-d> <C-r>=strftime('%Y-%m-%d %A')<CR>
cnoremap <C-t> <C-r>=strftime('%Y-%m-%dT%T%z')<CR>
cnoremap <C-d> <C-r>=strftime('%Y-%m-%d')<CR>

" Immediate feedback to correct habits
highlight HabitChange guifg=love cterm=underline
match HabitChange /recieve/
match HabitChange /recieve_message_chain/

" Focus command to close all buffers but the current one
command! Focus wa|%bd|e#

" Git commit message stuff
function! CreateGitHumansFile()
 let git_log = systemlist('git log --format="%aN <%aE>" "$@" --since "1 month ago"')
 let git_log = uniq(sort(git_log))
 let git_log = add(git_log, 'Co-authored-by:')
 let git_log = map(git_log, 'substitute(v:val, " ", " ", "g")')
 call writefile(git_log, '.git/humans.txt', 'b')
endfunction
autocmd FileType gitcommit nnoremap <buffer> <C-t> :.!git ticket<CR>
autocmd FileType gitcommit call CreateGitHumansFile()
" <C-n> completion for coauthor names, email addresses and 'Co-authored-by:' string
" See also https://vim.fandom.com/wiki/Use_abbreviations_for_frequently-used_words
autocmd FileType gitcommit setlocal dictionary+=.git/humans.txt
autocmd FileType gitcommit setlocal complete+=k
autocmd FileType gitcommit setlocal iskeyword+=-,:,<,.,+,@-@,>
