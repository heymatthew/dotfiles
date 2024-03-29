" .vimrc configuration file
" vint: -ProhibitAutocmdWithNoGroup

if !filereadable(expand('~/.vim/autoload/plug.vim'))
  echom 'Installing plug'
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')
Plug 'bronson/vim-visual-star-search'  " Vim multiline search
Plug 'dbmrq/vim-ditto'                 " Highlight repeated words
Plug 'heymatthew/vim-blinkenlights'    " Muted colourscheme
Plug 'junegunn/fzf.vim'                " Defaults
Plug 'junegunn/goyo.vim'               " Distraction free writing in vim
Plug 'junegunn/gv.vim'                 " git graph with :GV, :GV!, :GV?
Plug 'junegunn/vader.vim'              " Vimscript test framework
Plug 'junegunn/vim-easy-align'         " Align paragraph = with gaip=
Plug 'michaeljsmith/vim-indent-object' " Select indents as an object
Plug 'roman/golden-ratio'              " Splits follow golden ratio rules
Plug 'tpope/vim-abolish'               " Word conversions, including snake to pascal case
Plug 'tpope/vim-characterize'          " UTF8 outputs for ga binding
Plug 'tpope/vim-commentary'            " Toggle comments on lines
Plug 'tpope/vim-dadbod'                " Database from your vim
Plug 'tpope/vim-dispatch'              " Builds and tests with asynchronous adapters: https://vimeo.com/63116209
Plug 'tpope/vim-eunuch'                " Utils and typing shebang line causes file type re-detection with +x
Plug 'tpope/vim-fugitive'              " Git
Plug 'tpope/vim-jdaddy'                " JSON text objects (aj) and pretty print (gqaj) for json
Plug 'tpope/vim-obsession'             " Makes sessions easier to manage with :Obsess
Plug 'tpope/vim-rails'                 " For rails codebases
Plug 'tpope/vim-repeat'                " Lets you use . for surround and other plugins
Plug 'tpope/vim-rhubarb'               " Github extension for fugitive
Plug 'tpope/vim-sensible'              " Good defaults, love your work tpope!
Plug 'tpope/vim-speeddating'           " <ctrl>a and <ctrl>x works on dates and roman numerals. 7<C-a> will jump a week.
Plug 'tpope/vim-surround'              " Delete, or insert around text objects
Plug 'tpope/vim-unimpaired'            " <3 pairings that marry ] and ['s REALLY GOOD, 5 stars
Plug 'tpope/vim-vinegar'               " Better file browser
Plug 'vim-ruby/vim-ruby'               " make ruby files FAST
Plug 'vim-scripts/SyntaxAttr.vim'      " Display syntax highlighting attributes under cursor
Plug 'fatih/vim-go',  { 'do': ':GoInstallBinaries' }
Plug 'w0rp/ale',      { 'as': 'vim-ale' }
Plug 'junegunn/fzf',  { 'as': 'vim-fzf', 'dir': '~/code/fzf', 'do': 'yes \| ./install' }
call plug#end()

let g:fzf_preview_window = ['right,50%', 'ctrl-/']
let g:golden_ratio_autocommand = 0
let g:ale_set_highlights = 0               " remove highlights
let g:ale_set_loclist = 0                  " don't clobber location list
let g:ale_set_quickfix = 0                 " don't clobber quickfix list
let g:ale_virtualtext_cursor = 'disabled'  " don't show virtual text with errors

" detects background=light|dark from on terminal theme
" manually toggle background with yob
colorscheme blinkenlights

" Prefer splitting down or right
set splitright   " vertical windows go right
set splitbelow   " horizontal windows go below
autocmd FileType help wincmd L
nnoremap <C-w>f :vertical wincmd f<CR>
nnoremap <C-w>d :vertical wincmd d<CR>
nnoremap <C-w>] :vertical wincmd ]<CR>
nnoremap <C-w>^ :vertical wincmd ^<CR>
nnoremap <C-w>F :vertical wincmd F<CR>

" Set line numbers where possible
set number
autocmd FileType help setlocal number
let g:netrw_bufsettings = 'number'

set scrolloff=5                     " 5 lines always visible at top and bottom
set sidescrolloff=5                 " 5 characters always visible left and right when scrollwrap is set
set nojoinspaces                    " Single space after period when using J
set hlsearch                        " Highlight my searches :)
set ignorecase                      " Search case insensitive...
set smartcase                       " ... but not it begins with upper case
set magic                           " Allows pattern matching with special characters
set autoindent                      " indent on newlines
set smartindent                     " recognise syntax of files
set noswapfile nobackup             " git > swapfile, git > backup files
set wrap linebreak nolist           " wrap words, incompatable with visible whitespace (list and listchars)
set showcmd                         " show command on bottom right as it's typed
set belloff=all                     " I find terminal bells irritating
set shortmess-=S                    " show search matches, see https://stackoverflow.com/a/4671112
set history=1000                    " 1000 lines of command line and search history saved
set diffopt+=vertical               " vertical diffs
set viminfo='1000,<100,n~/.vim/info " Persist 1000 marks, and 100 lines per reg across sessions
set colorcolumn=120                 " Show 100th char visually
set nomodeline modelines=0          " Disable modelines as a security precaution
set foldminlines=3                  " Folds only operate on blocks more than 3 lines long
set nrformats-=octal                " Disable octal increment from <C-a>, i.e. 007 -> 010
set diffopt+=algorithm:histogram    " Format diffs with histogram algo https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
set cdpath="~/src"                  " cd to directories under ~src without explicit path
" set textwidth=100                 " hard wrap

" Set foldmethod but expand all when opening files
set foldmethod=syntax
autocmd BufRead * normal zR
autocmd Filetype fugitive   setlocal foldmethod=manual
autocmd Filetype haml       setlocal foldmethod=indent
autocmd Filetype sh         setlocal foldmethod=indent
autocmd Filetype eruby.yaml setlocal foldmethod=indent
autocmd FileType help       setlocal conceallevel=0

" Mapping Principles (WIP)
" 1. Common usage should use chords or single key presses
" 2. Less common things should be two character mnemonics
" 3. Uncommon useful things should be leader-based or vim commands

" space - read/write clipboard
nnoremap <space> "+
" visual space - read/write clipboard
vnoremap <space> "+
" go to vimrc
nnoremap <leader>v :edit $HOME/dotfiles/softlinks/.vimrc<CR>
" go to zshrc
nnoremap <leader>z :edit $HOME/dotfiles/softlinks/.zshrc<CR>
" go to scatchpad
nnoremap <leader>s :edit $HOME/scratchpad.md<CR>
" go to plugins
nnoremap <leader>p :edit $HOME/.vim/plugged<CR>
" goo - fuzzy find file
nnoremap go :FZF<CR>
" yank path
nnoremap yp :let @+=expand("%")<CR>:let @"=expand("%")<CR>
" toggle quickfix
nnoremap <expr> yoq empty(filter(getwininfo(), 'v:val.quickfix')) ? ':copen<CR>:resize 10%<CR>' : ':cclose<CR>'
" toggle ale - mnemonic riffs from tpope's unimpaired
nnoremap yoa :ALEToggleBuffer<CR>
" Toggle edit and write, similar to https://hemingwayapp.com
nnoremap <expr> yoe ToggleEditToWrite()
" toggle goyo - mnemonic riffs from tpope's unimpaired
nnoremap yog :Goyo<CR>
" Ale next - mnemonic riffs from tpope's unimpaired, clobbers :next
nnoremap ]a :ALENextWrap<CR>
" Ale previous - mnemonic riffs from tpope's unimpaired, clobbers :previous
nnoremap [a :ALEPreviousWrap<CR>
" quit buffer
nnoremap Q :bd<CR>
" display syntax of element under the cursor
nnoremap <F2> :call SyntaxAttr()<CR>
" clear search highlghts
nnoremap <BACKSPACE> :nohlsearch<CR>
" toggle previous file
nnoremap \ <C-^>
" find word under cursor
nnoremap <C-f> :silent Ggrep <cword><CR>
" visual find
vnoremap <C-f> y:silent Ggrep "<C-r>0"<CR>zz
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
" insert timestamp in command and insert mode
noremap! <C-t> <C-r>=strftime('%Y-%m-%dT%T%z')<CR>
" insert datestamp in command and insert mode
noremap! <C-d> <C-r>=strftime('%Y-%m-%d %A')<CR>
" git status
nnoremap gs :vert G<CR>
" git blame
nnoremap gb :Git blame<CR>
" w!! saves as sudo
cnoremap w!! w !sudo tee > /dev/null %
" Format markdown with pandoc. FIXME: pipe_tables https://pandoc.org/chunkedhtml-demo/8.9-tables.html
autocmd FileType markdown setlocal formatprg=pandoc\ --from\ markdown\ --to\ markdown
" Format json files with jq
autocmd FileType json setlocal formatprg=jq
" Workaround: Allow other content to load in :Git pane, https://github.com/tpope/vim-fugitive/issues/2272
autocmd BufEnter * if &filetype == 'fugitive' | set nowinfixbuf | endif

" focus - close all buffers but the current one
command! Focus wa|%bd|e#
" changes - quickfix jumplist of hunks since branching
command! Changes exec ':Git difftool ' . systemlist('git merge-base origin/HEAD HEAD')[0]
" now - insert timestamp after cursor
command! Now normal! a<C-r>=strftime('%Y-%m-%dT%T%z')<CR>
" today - insert iso date after cursor
command! Today normal! a<C-r>=strftime('%Y-%m-%d')<CR>
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
" spellcheck commit messages
autocmd Filetype gitcommit setlocal spell
" restore cursor position on file open
autocmd BufWinEnter * call PositionCursor()
" Turn off syntax highlighting in large files
autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | setlocal foldmethod=manual | echo 'chonky file: syntax off, fold manual' | endif
" Window resize sets equal splits https://hachyderm.io/@tpope/109784416506853805
autocmd VimResized * wincmd =
" ...and new splits that might open, e.g. v from netrw
let s:resize_exceptions = ['qf', 'loc', 'fugitive', 'help']
autocmd WinNew * if index(s:resize_exceptions, &filetype) == -1 | wincmd = | endif
" ...and help windows are 90 chars wide
autocmd FileType help vertical resize 90
" reload vimrc on edits, credit http://howivim.com/2016/damian-conway
autocmd! BufWritePost $MYVIMRC source $MYVIMRC
autocmd! BufWritePost $HOME/dotfiles/softlinks/.vimrc source $MYVIMRC
" reload plugins on save
autocmd! BufWritePost ~/.vim/plugged/**/* nested source $MYVIMRC
" open location/quickfix after :make, :grep, :lvimgrep and friends
autocmd! QuickFixCmdPost [^l]* cwindow
autocmd! QuickFixCmdPost l*    cwindow

" Whitespace management
set                                 expandtab   tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype markdown  setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype go        setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype perl      setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype ruby      setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype sh        setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype julia     setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype gitconfig setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4

" Filetype detection overrides
autocmd BufNewFile,BufRead .env* setlocal filetype=sh

" Debugging reminders
autocmd FileType ruby :iabbrev <buffer> puts puts<ESC>mdA # FIXME: commit = death<ESC>`da
autocmd FileType ruby :iabbrev <buffer> binding binding<ESC>mdA # FIXME: commit = death<ESC>`da

" Cludges and workarounds
" FIXME: Report gf on a class in a Rails project opens it, but <C-w>f does not
autocmd FileType ruby nmap <buffer> <C-w>f <C-w>vgf
" <C-l> toggles syntax too, ruby's syntax parser can get slow
autocmd FileType ruby nnoremap <buffer> <C-l> <C-l>:setlocal syntax=off<CR>:setlocal syntax=on<CR>

" K uses ri for ruby
autocmd Filetype ruby setlocal keywordprg=ri
" K uses dictionary for markdown
autocmd Filetype markdown setlocal keywordprg=dict
" markdown complete ignores case for matches but uses the context
autocmd Filetype markdown setlocal ignorecase infercase

" Writing Prose
set spelllang=en_nz
set dictionary=/usr/share/dict/words
set thesaurus=~/.vim/thesaurus/mthesaur.txt
if !filereadable(&thesaurus)
  echom 'Downloading thesaurus file'
  silent !curl -fLo ~/.vim/thesaurus/mthesaur.txt --create-dirs https://raw.githubusercontent.com/zeke/moby/master/words.txt
endif
" z_ - Dictionary lookup word under cursor
nnoremap z_ :!dict <cword><CR>
" Experimental thesaurus lookup
if filereadable(&thesaurus)
  let thesaurus = {}

  for line in readfile(&thesaurus)
    let parts = split(line, ',')
    let [word, synonyms] = [parts[0], parts[1:]]
    let thesaurus[word] = synonyms
  endfor

  " FIXME: This works, but there's a bug to squash
  " SyntaxError - E492: Not an editor command: <selected_word> (see vim-jp/vim-vimlparser)
  function! Suggest(thesaurus, word)
    let synonyms = a:thesaurus[a:word][:&lines - 2]
    let synonyms = map(synonyms, { i, synonym -> (i+1) . '. ' . synonym })
    let choice = inputlist(synonyms)
    let replace = a:thesaurus[a:word][choice-1]
    echo "\nYou selected " . replace
    exec 'normal! ciw' . replace
  endfunction

  " z- thesaurus, mnemonic z= spelling lookup
  " Alternative to nnoremap z- viwA<C-x><C-t>
  nnoremap z- :call Suggest(thesaurus, expand('<cword>'))<CR>
endif

" See https://vim.fandom.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
let s:cursor_exceptions = ['qf', 'loc', 'fugitive', 'gitcommit', 'gitrebase']
function! PositionCursor()
  if index(s:cursor_exceptions, &filetype) == -1 && line("'\"") <= line('$')
    normal! g`"
    return 1
  endif
endfunction

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

" Git commit message stuff
function! GitHumans()
 let humans = systemlist('git log --format="%aN <%aE>" "$@" --since "1 year ago"')
 let humans = uniq(sort(humans))
 let humans = filter(humans, {index, val -> val !~ 'noreply'})
 let humans = map(humans, '"Co-Authored-By: " . v:val')
 return humans
endfunction

function! ToggleEditToWrite()
  if &spell || g:ale_enabled
    echo 'Writer focus'
    set nospell
    ALEDisable
    DittoOff
  else
    echo 'Editor focus'
    set spell
    ALEEnable
    Ditto
  endif
endfunction

" Deprecations and Habit Changes
highlight HabitChange guifg=love cterm=underline
match HabitChange /recieve/
match HabitChange /recieve_message_chain/
" Remove deprecated fugitive commands to unclog tab completion
" see ~/.vim/plugged/vim-fugitive/plugin/fugitive.vim
try | delcommand Gbrowse | catch | endtry
try | delcommand Gremove | catch | endtry
try | delcommand Grename | catch | endtry
try | delcommand Gmove | catch | endtry
