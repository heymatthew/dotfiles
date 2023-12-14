" .vimrc configuration file

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
Plug 'junegunn/goyo.vim'               " Distraction free writing in vim
Plug 'heymatthew/vim-blinkenlights'
Plug 'junegunn/vader.vim'              " Vimscript test framework
Plug 'junegunn/vim-easy-align'         " Align paragraph = with gaip=
Plug 'vim-scripts/SyntaxAttr.vim'      " Display syntax highlighting attributes under cursor
Plug 'roman/golden-ratio'              " Splits follow golden ratio rules
call plug#end()

let g:fzf_preview_window = ['right,50%', 'ctrl-/']
let g:golden_ratio_autocommand = 0
let g:ale_set_highlights = 0               " remove highlights
let g:ale_set_loclist = 0                  " don't clobber location list
let g:ale_set_quickfix = 0                 " don't clobber quickfix list
let g:ale_virtualtext_cursor = 'disabled'  " don't show virtual text with errors

" Dark mode isn't as good for your eyes as you believe
" https://www.wired.co.uk/article/dark-mode-chrome-android-ios-science
" FIXME: Extract to function, detect system
if !empty($LC_APPEARANCE)
  exec 'set background=' . $LC_APPEARANCE
endif

colorscheme blinkenlights
set colorcolumn=120

augroup vim_fugitive " for tpope/vim-fugitive
  " automatically open the location/quickfix window after :make, :grep, :lvimgrep and friends if there are valid locations/errors
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    cwindow

  " Show diffs since master in quickfix list

  " Always use vertical diffs
  set diffopt+=vertical
augroup END

augroup ale " for w0rp/ale
augroup END

" Move default where splits open
set splitright   " vertical windows go right
set splitbelow   " horizontal windows go below
" help files
autocmd FileType help wincmd L

" Show line numbers in files, help, and netrw
set number
autocmd FileType help setlocal number
let g:netrw_bufsettings = 'number'

" Window resize events make splits equal
" https://hachyderm.io/@tpope/109784416506853805
autocmd VimResized * wincmd =
" ...and new splits that might open, e.g. v from netrw
let s:resize_exceptions = ['qf', 'loc', 'fugitive']
autocmd WinNew * if index(s:resize_exceptions, &ft) == -1 | wincmd = | endif

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

set scrolloff=5            " 5 lines always visible at top and bottom
set sidescrolloff=5        " 5 characters always visible left and right when scrollwrap is set
set nojoinspaces           " Single space after period when using J
set hlsearch               " Highlight my searches :)
set ignorecase             " Search case insensitive...
set smartcase              " ... but not it begins with upper case
set magic                  " Allows pattern matching with special characters
set autoindent             " indent on newlines
set smartindent            " recognise syntax of files
set noswapfile nobackup    " git > swapfile, git > backup files
set wrap linebreak nolist  " wrap words, incompatable with visible whitespace (list and listchars)
set showcmd                " show command on bottom right as it's typed
set belloff=all            " I find terminal bells irritating
set mouse=a                " Looks like this is part of neovim defaults
set shortmess-=S           " show search matches, see https://stackoverflow.com/a/4671112
set history=1000           " 1000 lines of command line and search history saved

" set textwidth=100         " Automatically insert newlines
" set colorcolumn=100       " Show 100th char visually

" Set foldmethod but expand all when opening files
set foldmethod=syntax
autocmd BufRead * normal zR
autocmd Filetype fugitive setlocal foldmethod=manual
autocmd Filetype haml     setlocal foldmethod=indent

" space - read/write clipboard
nnoremap <space> "+
" visual space - read/write clipboard
vnoremap <space> "+
" read vimrc
nnoremap rv :e $HOME/dotfiles/softlinks/.vimrc<CR>
" read theme
nnoremap rt :exec 'edit ' . plug_dir . '/vim-blinkenlights/colors/blinkenlights.vim'<CR>
" read zshrc
nnoremap rz :e $HOME/dotfiles/softlinks/.zshrc<CR>
" read commit - edit commit template
nnoremap rc :e ~/.gitmessage<CR>ggi<C-r>=GitHumans()<CR>
" git status
nnoremap gs :vert G<CR>
" git log
nnoremap gl :vert G log --oneline -100<CR>
" git rebase
nnoremap gr :vert G rebase --interactive origin/HEAD<CR>
" go - fuzzy find file
nnoremap go :FZF<CR>
" read scatchpad
nnoremap rs :e $HOME/scratchpad.md<CR>
" yank path
nnoremap yp :let @+=expand("%")<CR>:let @"=expand("%")<CR>
" switch goyo - mnemonic riffs from tpope's unimpaired
nnoremap yog :Goyo<CR>
" next eRror - mnemonic riffs from tpope's unimpaired
nnoremap ]r :ALENextWrap<CR>
" previous eRror - mnemonic riffs from tpope's unimpaired
nnoremap [r :ALEPreviousWrap<CR>
" quit buffer
nnoremap Q :bd<CR>
" display syntax of element under the cursor
nnoremap <F2> :call SyntaxAttr()<CR>
" clear search highlghts
nnoremap <BACKSPACE> :nohlsearch<CR>
" toggle previous file
nnoremap \ <C-^>
" find word under cursor
nnoremap <C-f> yiw:silent Ggrep "<C-r>0"<CR>
" visual find
vnoremap <C-f> y:silent   Ggrep "<C-r>0"<CR>zz
" visual interactive align - vip<Enter>
vnoremap <Enter> <Plug>(EasyAlign)
" interactive align text object - gaip
nnoremap ga <Plug>(EasyAlign)
" GoldenRatio mnemonic, <C-w>- is like <C-w>=
nnoremap <silent> <C-w>- :GoldenRatioResize<CR>
" enhancement - <C-w>n splits are vertical
nnoremap <C-w>n :vert new<CR>
" enhancement - next search centers page
nnoremap n nzz
" enhancement - reverse search centers page
nnoremap N Nzz
" enhancement - page up centers page
nnoremap <C-u> <C-u>zz
" enhancement - page down centers page
nnoremap <C-d> <C-d>zz
" enhancement - pasting over a visual selection keeps content
vnoremap <silent> <expr> p <sid>VisualPut()

" focus - close all buffers but the current one
command! Focus wa|%bd|e#
" changes - quickfix jumplist of hunks since branching
command! Changes exec ':G difftool ' . systemlist('git merge-base origin/HEAD HEAD')[0]
" now - insert timestamp after cursor
command! Now normal! a<C-r>=strftime('%Y-%m-%dT%T%z')<CR>
" today - insert iso date after cursor
command! Today normal! a<C-r>=strftime('%Y-%m-%d')<CR>

" Spelling
autocmd Filetype gitcommit setlocal spell
autocmd Filetype markdown  setlocal spell

" Vim autojump to last position VIM was at when opening a file.
" See --> http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
"
" Persist ~/.vim/info with 1000 file marks, 100 lines per register
" See https://vimhelp.org/options.txt.html#%27viminfo%27
set viminfo='1000,<100,n~/.vim/info

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
function! s:VisualPut()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<CR>"
endfunction

" Insert timestamps after cursor
inoremap <C-t> <C-r>=strftime('%Y-%m-%dT%T%z')<CR>
inoremap <C-d> <C-r>=strftime('%Y-%m-%d %A')<CR>
cnoremap <C-t> <C-r>=strftime('%Y-%m-%dT%T%z')<CR>
cnoremap <C-d> <C-r>=strftime('%Y-%m-%d')<CR>

" Immediate feedback to correct habits
highlight HabitChange guifg=love cterm=underline
match HabitChange /recieve/
match HabitChange /recieve_message_chain/

" Git commit message stuff
function! GitHumans()
 let humans = systemlist('git log --format="%aN <%aE>" "$@" --since "1 month ago"')
 let humans = uniq(sort(humans))
 let humans = filter(humans, {index, val -> val !~ 'noreply'})
 let humans = map(humans, '"Co-Authored-By: " . v:val')
 return humans
endfunction
