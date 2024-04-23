" .vimrc configuration file

" ==[ Table of contents ]=======================================================
" Plugins ..................... 3rd party libraries
" Settings .................... Default behaviours
" Custom Mappings ............. Extend functionality with hotkeys
" Functions ................... Behaviours with 1+ editor actions


augroup mods/plugins
  " ==[ Plugins ]=================================================================
  if !filereadable(expand('~/.vim/autoload/plug.vim'))
    echom 'Installing plug'
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    try
      source ~/.vim/autoload/plug.vim
      source $MYVIMRC
    catch
      PlugInstall | source $MYVIMRC 
    endtry
    finish
  endif

  call plug#begin('~/.vim/plugged')
  Plug 'bronson/vim-visual-star-search'  " Vim multiline search
  Plug 'dbmrq/vim-ditto'                 " Highlight repeated words
  Plug 'dense-analysis/ale',             " Linter
  Plug 'fatih/vim-go',  { 'do': ':GoInstallBinaries' }
  Plug 'heymatthew/vim-blinkenlights'    " Muted colourscheme
   Plug 'luxed/ayu-vim'                   " Paper-like colourscheme
  Plug 'junegunn/fzf',  { 'dir': '~/src/fzf', 'do': 'yes \| ./install' }
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
  call plug#end()
augroup END

augroup mods/settings | autocmd!
  " ==[ Settings ]================================================================
  " Setting principles (WIP)
  " 1. Interface minimalism and consistency
  " 2. Portability
  " 3. Stability

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
  set colorcolumn=120                 " Show 100th char visually
  set nomodeline modelines=0          " Disable modelines as a security precaution
  set foldminlines=3                  " Folds only operate on blocks more than 3 lines long
  set nrformats-=octal                " Disable octal increment from <C-a>, i.e. 007 -> 010
  set diffopt+=algorithm:histogram    " Format diffs with histogram algo https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
  set cdpath="~/src"                  " cd to directories under ~src without explicit path
  set noruler                         " not using this, unset form tpope/vim-sensible
  " set jumpoptions+=stack            " <C-o> behaves like a stack. Jumping throws away <C-i> from :jumps

  set termguicolors " true colour support
  colorscheme ayu

  let g:ale_set_highlights = 0                       " remove highlights
  let g:ale_set_loclist = 0                          " don't clobber location list
  let g:ale_set_quickfix = 0                         " don't clobber quickfix list
  let g:ale_virtualtext_cursor = 'disabled'          " don't show virtual text with errors
  let g:golden_ratio_autocommand = 0                 " disable golden ratio by default
  let g:fzf_preview_window = ['right,50%', 'ctrl-/'] " configure popup window

  " Prefer splitting down or right
  set splitright   " vertical windows go right
  set splitbelow   " horizontal windows go below
  autocmd FileType help wincmd L
  nnoremap <C-w>f :vertical wincmd f<CR>
  nnoremap <C-w>d :vertical wincmd d<CR>
  nnoremap <C-w>] :vertical wincmd ]<CR>
  nnoremap <C-w>^ :vertical wincmd ^<CR>
  nnoremap <C-w>F :vertical wincmd F<CR>

  " Whitespace management
  set                                 expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype markdown  setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype go        setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype perl      setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype ruby      setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype sh        setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype julia     setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype gitconfig setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype lua       setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype html      setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype eruby     setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2

  " Writing Prose
  set spelllang=en_nz
  set dictionary=/usr/share/dict/words
  set thesaurus=~/.vim/thesaurus/mthesaur.txt
  " markdown complete ignores case for matches but uses the context
  autocmd Filetype markdown setlocal ignorecase infercase

  if has('nvim')
    " Persist 1000 marks, and 100 lines per reg across nvim sessions
    set shada='1000,<100,n~/.vim/shada 
  else
    " Persist 1000 marks, and 100 lines per reg across sessions
    set viminfo='1000,<100,n~/.vim/info
    " note, vim detects background=light|dark from terminal theme
    " manually toggle background with yob
    " Cludges and workarounds for slow ruby parsing
    " vim-ruby ships with vim, I just find folds and syntax really slow
    " neovim uses treesitter which has it's own quirks
    " FIXME: Report gf on a class in a Rails project opens it, but <C-w>f does not
    autocmd FileType ruby nmap <buffer> <C-w>f <C-w>vgf
    " <C-l> toggles syntax too, ruby's syntax parser can get slow
    autocmd FileType ruby nnoremap <buffer> <C-l> <C-l>:setlocal syntax=off<CR>:setlocal syntax=on<CR>
  end

  " Debugging reminders
  autocmd FileType ruby :iabbrev <buffer> puts puts<ESC>m`A # FIXME: commit = death<ESC>``a
  autocmd FileType ruby :iabbrev <buffer> binding binding<ESC>m`A # FIXME: commit = death<ESC>``a

  " Set foldmethod but expand all when opening files
  set foldmethod=syntax
  autocmd BufRead * normal zR
  autocmd Filetype fugitive   setlocal foldmethod=manual
  autocmd Filetype haml       setlocal foldmethod=indent
  autocmd Filetype sh         setlocal foldmethod=indent
  autocmd Filetype eruby.yaml setlocal foldmethod=indent
  autocmd Filetype yaml       setlocal foldmethod=indent
  autocmd Filetype eruby      setlocal foldmethod=indent
  autocmd Filetype vim        setlocal foldmethod=indent

  " Don't hide syntax for |:links| and *:marks* in help files
  autocmd FileType help setlocal conceallevel=0

  " Filetype detection overrides
  autocmd BufNewFile,BufRead .env* setlocal filetype=sh

  " Workaround: Allow other content to load in any pane, https://github.com/tpope/vim-fugitive/issues/2272
  if has('winfixbuf')
    autocmd BufEnter * if &winfixbuf | set nowinfixbuf | endif
  endif
  " Turn off syntax highlighting in large files
  autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | setlocal foldmethod=manual | echo 'chonky file: syntax off, fold manual' | endif
  " Window resize sets equal splits https://hachyderm.io/@tpope/109784416506853805
  autocmd VimResized * wincmd =
  " ...and new splits that might open, e.g. v from netrw
  let s:resize_exceptions = ['qf', 'loc', 'fugitive', 'help']
  autocmd WinNew * if index(s:resize_exceptions, &filetype) == -1 | wincmd = | endif
  " ...and help windows are 90 chars wide
  autocmd FileType help vertical resize 90
  " reload plugins on save
  autocmd BufWritePost ~/.vim/plugged/**/* nested source $MYVIMRC
  " open location/quickfix after :make, :grep, :lvimgrep and friends
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    cwindow

  " FIXME: use pipe_tables https://pandoc.org/chunkedhtml-demo/8.9-tables.html
  autocmd FileType markdown setlocal formatprg=pandoc\ --from\ markdown\ --to\ markdown
  autocmd Filetype ruby     setlocal keywordprg=ri     " Lookup docs with ri
  autocmd FileType json     setlocal formatprg=jq      " Format json files with jq
  autocmd Filetype markdown setlocal keywordprg=dict   " K uses dictionary for markdown

  " See https://vim.fandom.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
  " restore cursor position on file open
  autocmd BufWinEnter * call PositionCursor()

  " Deprecations and Habit Changes
  " highlight HabitChange guifg=love cterm=underline
  " match HabitChange /recieve/
  " match HabitChange /recieve_message_chain/

  " Remove deprecated fugitive commands to unclog tab completion
  " see ~/.vim/plugged/vim-fugitive/plugin/fugitive.vim
  try | delcommand Gbrowse | catch | endtry
  try | delcommand Gremove | catch | endtry
  try | delcommand Grename | catch | endtry
  try | delcommand Gmove | catch | endtry
augroup END

augroup mods/mappings | autocmd!
  " ==[ Custom Mappings ]=========================================================
  " Mapping Principles (WIP)
  " 1. Common usage should use chords or single key presses
  " 2. Less common things should be two character mnemonics
  " 3. Uncommon useful things should be leader-based or vim commands

  " git status
  nnoremap gs :vert Git<CR>
  " nnoremap gS :Gedit :<CR>
  " git blame
  nnoremap gB :Git blame<CR>
  " changes (gC) - quickfix jumplist of hunks since branching
  command! Changes exec ':Git difftool ' . systemlist('git merge-base origin/HEAD HEAD')[0]
  nnoremap gC :Changes<CR>
  " upstream diffsplit (dU)
  command! DiffsplitUpstream exec ':Gdiffsplit ' . systemlist('git merge-base origin/HEAD HEAD')[0]
  nnoremap dU :DiffsplitUpstream<CR>
  " diff changes (dC)
  nnoremap dC :Gdiffsplit<CR>
  " edit commit template
  autocmd filetype fugitive nmap <buffer> ct
    \ :!cp ~/.git/message .git/message.bak<CR>
    \ :!cp ~/.gitmessage .git/message<CR>
    \ :!git config commit.template '.git/message'<CR>
    \ :edit .git/message<CR>
    \ Go<C-r>=GitHumans()<CR>
    \ <ESC>gg
  " git log
  autocmd filetype fugitive nnoremap <buffer> gl :G log --oneline -100<CR>
  " <C-l> refreshes git pane, like netrw refresh
  autocmd filetype fugitive nnoremap <buffer> <C-l> :Git<CR><C-l>
  " open github commands
  autocmd filetype fugitive nnoremap <buffer> gh<Space> :Git hub 
  " create empty commit, good for 
  autocmd filetype fugitive nnoremap <buffer> ce :Git commit --allow-empty<CR>
  " spellcheck commit messages
  autocmd Filetype gitcommit setlocal spell
  " GoldenRatio mnemonic, <C-w>- is like <C-w>=
  nnoremap <silent> <C-w>- :GoldenRatioResize<CR>
  " toggle ale - mnemonic riffs from tpope's unimpaired
  nnoremap yoa :ALEToggleBuffer<CR>
  " Ale next - mnemonic riffs from tpope's unimpaired, clobbers :next
  nnoremap ]a :ALENextWrap<CR>
  " Ale previous - mnemonic riffs from tpope's unimpaired, clobbers :previous
  nnoremap [a :ALEPreviousWrap<CR>
  " Toggle edit and write, similar to https://hemingwayapp.com
  nnoremap <expr> yoe ToggleEditToWrite()
  " thesaurus
  if !filereadable(&thesaurus)
    echom 'Downloading thesaurus file'
    silent !curl -fLo ~/.vim/thesaurus/mthesaur.txt --create-dirs https://raw.githubusercontent.com/zeke/moby/master/words.txt
  endif
  " Experimental thesaurus lookup
  if filereadable(&thesaurus)
    let thesaurus = {}
    for line in readfile(&thesaurus)
      let parts = split(line, ',')
      let [word, synonyms] = [parts[0], parts[1:]]
      let thesaurus[word] = synonyms
    endfor
    " z- thesaurus, mnemonic z= spelling lookup
    " Alternative to nnoremap z- viwA<C-x><C-t>
    nnoremap z- :call Suggest(thesaurus, expand('<cword>'))<CR>
  endif
  " go - fuzzy find file
  nnoremap go :FZF<CR>
  " quick edit and reload for fast iteration. Credit http://howivim.com/2016/damian-conway
  nnoremap <leader>v :edit $HOME/dotfiles/softlinks/.vimrc<CR>
  autocmd BufWritePost ~/dotfiles/softlinks/.vimrc source ~/dotfiles/softlinks/.vimrc
  " go to zshrc
  nnoremap <leader>z :edit $HOME/dotfiles/softlinks/.zshrc<CR>
  " go to scatchpad
  nnoremap <leader>s :edit $HOME/scratchpad.md<CR>
  " go to plugins
  nnoremap <leader>p :edit $HOME/.vim/plugged<CR>
  " space - read/write clipboard
  nnoremap <space> "+
  " visual space - read/write clipboard
  vnoremap <space> "+
  " yank path
  nnoremap yp :let @+=expand("%")<CR>:let @"=expand("%")<CR>
  " toggle goyo - mnemonic riffs from tpope's unimpaired
  nnoremap yog :Goyo<CR>
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
  " enhancement - <C-w>n splits are vertical
  nnoremap <C-w>n :vert new<CR>
  " enhancement - next search centers page
  nnoremap n nzz
  " enhancement - reverse search centers page
  nnoremap N Nzz
  " insert timestamp in command and insert mode
  noremap! <C-t> <C-r>=strftime('%Y-%m-%dT%T%z')<CR>
  " insert datestamp in command and insert mode
  noremap! <C-d> <C-r>=strftime('%Y-%m-%d %A')<CR>
  " w!! saves as sudo
  cnoremap w!! w !sudo tee > /dev/null %
  " focus - close all buffers but the current one
  command! Focus wa|%bd|e#
  " now - insert timestamp after cursor
  command! Now normal! a<C-r>=strftime('%Y-%m-%dT%T%z')<CR>
  " today - insert iso date after cursor
  command! Today normal! a<C-r>=strftime('%Y-%m-%d')<CR>
  " Toggle quickfix
  nnoremap <expr> yoq IsQuickfixClosed() ? ':copen<CR>:resize 10%<CR>' : ':cclose<CR>'
  " enhancement - pasting over a visual selection keeps content
  vnoremap <silent> <expr> p <sid>VisualPut()
augroup END

augroup mods/functions | autocmd!
  " ==[ Functions ]=============================================================
  " Function Principles (WIP)
  " 1. Behaviours should be named with VerbNoun
  " 2. Checks prefix with Is or Has

  " toggle quickfix
  function! IsQuickfixClosed()
    let quickfix_windows = filter(getwininfo(), { i, v -> v.quickfix && v.tabnr == tabpagenr() })
    return empty(quickfix_windows)
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

  let s:cursor_exceptions = ['qf', 'loc', 'fugitive', 'gitcommit', 'gitrebase']
  function! PositionCursor()
    if index(s:cursor_exceptions, &filetype) == -1 && line("'\"") <= line('$')
      normal! g`"
      return 1
    endif
  endfunction

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

  " FIXME: This works, but there's a bug to squash
  " SyntaxError - E492: Not an editor command: <selected_word> (see vim-jp/vim-vimlparser)
  function! Suggest(thesaurus, word)
    let synonyms = a:thesaurus[a:word][:&lines - 2]
    let synonyms = map(synonyms, { i, synonym -> (i+1) . '. ' . synonym })
    let choice = inputlist(synonyms)
    let replace = a:thesaurus[a:word][choice-1]
    echo "\nYou selected " . replace
    execute 'normal! ciw' . replace
  endfunction
augroup END
