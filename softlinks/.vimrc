" .vimrc configuration file

" ==[ Table of contents ]===========================================================================
" Plugins ..................... 3rd party libraries
" Settings .................... Default behaviours
" Custom Mappings ............. Extend functionality with hotkeys
" Functions ................... Behaviours with 1+ editor actions


augroup vimrc/plugins
  " ==[ Plugins ]===================================================================================
  if !filereadable(expand('~/.vim/autoload/plug.vim'))
    echom 'Installing plug'
    silent !curl --create-dirs
      \ -fLo ~/.vim/autoload/plug.vim
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    try
      source ~/.vim/autoload/plug.vim
      source $MYVIMRC
    catch
      PlugInstall | source $MYVIMRC 
    endtry
    finish
  endif

  " thesaurus
  set thesaurus=~/.vim/thesaurus/mthesaur.txt
  if !filereadable(&thesaurus)
    echom 'Downloading thesaurus file'
    silent !curl --create-dirs
      \ -fLo ~/.vim/thesaurus/mthesaur.txt
      \ https://raw.githubusercontent.com/zeke/moby/master/words.txt
  endif

  call plug#begin('~/.vim/plugged')
    Plug 'bronson/vim-visual-star-search'  " Vim multiline search
    Plug 'dbmrq/vim-ditto'                 " Highlight repeated words
    Plug 'dense-analysis/ale',             " Linter
    Plug 'fatih/vim-go',  { 'do': ':GoInstallBinaries' }
    Plug 'heymatthew/vim-blinkenlights'    " Muted colourscheme
    Plug 'junegunn/fzf',  { 'dir': '~/src/fzf', 'do': 'yes \| ./install' }
    Plug 'preservim/vim-textobj-sentence'  " Extend native sentence objects and motions
    Plug 'junegunn/fzf.vim'                " Defaults
    Plug 'junegunn/goyo.vim'               " Distraction free writing in vim
    Plug 'junegunn/gv.vim'                 " git graph with :GV, :GV!, :GV?
    Plug 'junegunn/vader.vim'              " Vimscript test framework
    Plug 'junegunn/vim-easy-align'         " Align paragraph = with gaip=
    Plug 'michaeljsmith/vim-indent-object' " Select indents as an object
    Plug 'roman/golden-ratio'              " Splits follow golden ratio rules
    Plug 'rose-pine/neovim', { 'as': 'neo-pine' }
    Plug 'tpope/vim-abolish'               " Word conversions, including snake to pascal case
    Plug 'tpope/vim-characterize'          " UTF8 outputs for ga binding
    Plug 'tpope/vim-commentary'            " Toggle comments on lines
    Plug 'tpope/vim-dadbod'                " Database from your vim
    Plug 'tpope/vim-dispatch'              " Async adapters for build/test: https://vimeo.com/63116209
    Plug 'tpope/vim-eunuch'                " Unix utils. Also shebang will set filetype and +x
    Plug 'tpope/vim-fugitive'              " Git.
    Plug 'tpope/vim-jdaddy'                " JSON text objects (aj) and pretty print (gqaj)
    Plug 'tpope/vim-obsession'             " Makes sessions easier to manage with :Obsess
    Plug 'tpope/vim-rails'                 " For rails codebases
    Plug 'tpope/vim-repeat'                " Lets you use . for surround and other plugins
    Plug 'tpope/vim-rhubarb'               " Github extension for fugitive
    Plug 'tpope/vim-sensible'              " Good defaults, love your work tpope!
    Plug 'tpope/vim-speeddating'           " <C-a> / <C-x> for dates and Roman nums. 7<C-a> for 1 week
    Plug 'tpope/vim-surround'              " Delete, or insert quotes/brackets with text objects
    Plug 'tpope/vim-unimpaired'            " <3 pairings that marry ] and ['s REALLY GOOD, 5 stars
    Plug 'tpope/vim-vinegar'               " Enhancements for netrw
    Plug 'vim-ruby/vim-ruby'               " Bleading edge syntax highlighting
    Plug 'vim-scripts/SyntaxAttr.vim'      " Display syntax highlighting attributes under cursor
  call plug#end()
augroup END

augroup vimrc/settings | autocmd!
  " ==[ Settings ]==================================================================================
  " Setting principles (WIP)
  " 1. Interface minimalism
  " 2. Portability over monolythic
  " 3. Experimentation over stability

  set scrolloff=5                  " 5 lines always visible at top and bottom
  set sidescrolloff=5              " 5 characters visible left/right, assuming scrollwrap is set
  set nojoinspaces                 " Single space after period when using J
  set hlsearch                     " Highlight my searches :)
  set ignorecase                   " Search case insensitive...
  set smartcase                    " ... but not it begins with upper case
  set magic                        " Allows pattern matching with special characters
  set autoindent                   " indent on newlines
  set smartindent                  " recognise syntax of files
  set noswapfile nobackup          " git > swapfile, git > backup files
  set wrap linebreak nolist        " wrap words, incompatable w' visible whitespace (list/listchars)
  set showcmd                      " show command on bottom right as it's typed
  set belloff=all                  " I find terminal bells irritating
  set shortmess-=S                 " show search matches, see https://stackoverflow.com/a/4671112
  set history=1000                 " 1000 lines of command line and search history saved
  set diffopt+=vertical            " vertical diffs
  set colorcolumn=100              " Show 100th char visually
  set nomodeline modelines=0       " Disable modelines as a security precaution
  set foldminlines=3               " Folds only operate on blocks more than 3 lines long
  set nrformats-=octal             " Disable octal increment from <C-a>, i.e. 007 -> 010
  set diffopt+=algorithm:histogram " Format diffs with histogram algo
                                   " https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
  set cdpath="~/src"               " cd to directories under ~src without explicit path
  set noruler                      " not using this, unset form tpope/vim-sensible
  set mouse=                       " turn off mouse

  let g:fzf_preview_window = ['right,50%', 'ctrl-/'] " configure popup window
  let g:ale_set_highlights = 0                       " remove highlights
  let g:ale_set_loclist = 0                          " don't clobber location list
  let g:ale_set_quickfix = 0                         " don't clobber quickfix list
  let g:ale_virtualtext_cursor = 'disabled'          " don't show virtual text with errors
  let g:golden_ratio_autocommand = 0                 " disable golden ratio by default
  let g:fugitive_legacy_commands = 0                 " don't populate deprecated fugitive commands

  set termguicolors " true colour support
  if has('nvim')
    lua require("rose-pine").setup({ dark_variant = 'moon' })
    colorscheme rose-pine
  else
    colorscheme blinkenlights
  end

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
    " autocmd FileType ruby nmap <buffer> <C-w>f <C-w>vgf
    " <C-l> toggles syntax too, ruby's syntax parser can get slow
    autocmd FileType ruby nnoremap <buffer> <C-l>
      \ <C-l>:setlocal syntax=off<CR>:setlocal syntax=on<CR>

    " vim-textobj-sentence
    autocmd FileType markdown call textobj#sentence#init()
    autocmd FileType text call textobj#sentence#init()
    autocmd FileType yaml call textobj#sentence#init()
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

  " Workaround: Disable protections on windows, https://github.com/tpope/vim-fugitive/issues/2272
  if has('winfixbuf')
    autocmd BufEnter * if &winfixbuf | set nowinfixbuf | endif
  endif
  " Turn off syntax highlighting in large files
  autocmd BufWinEnter * call <SID>ConditionalSyntaxDisable() 
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
augroup END

augroup vimrc/mappings | autocmd!
  " ==[ Custom Mappings ]===========================================================================
  " Mapping Principles (WIP)
  " 1. Trial native vim before mapping
  " 2. Consistency: Rif off existing mnemonics
  " 3. Common usage: use chords, single or two key mnemonics
  " 4. Less common: Leader-based or vim commands

  " git status
  nnoremap gs :vert Git<CR>
  " nnoremap gS :Gedit :<CR>
  " git blame
  nnoremap gb :Git blame<CR>
  " git blame with copy paste detection
  nnoremap gB :Git blame -C -M<CR>
  " blame opens commit in Github
  autocmd filetype fugitiveblame nmap <buffer> gx ^:GBrowse <cword><CR>
  " git and fugitive open commit in Github
  autocmd filetype git,fugitive nmap <buffer> gx :GBrowse <cword><CR>
  " find merges from a blame window
  autocmd filetype fugitiveblame nmap <buffer> m
    \ ^
    \ :call <SID>TrackDefaultBranch()<CR>
    \ :Git log <cword>..origin/head --ancestry-path --merges --reverse<CR>
  " changes (gC) - quickfix jumplist of hunks since branching
  nnoremap gC :call <SID>QuickfixChangelist()<CR>
  " diff changes (dC)
  nnoremap dc :call <SID>DiffBuffer()<CR>
  " close fugitive diffs
  nnoremap dq :call fugitive#DiffClose()<CR>
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
  " commit plan, good for creating commits ahead of implementation
  " TODO: bail if local changes, that's not a plan anymore
  autocmd filetype fugitive nnoremap <buffer> cp :Git commit --allow-empty<CR>
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
  " z- thesaurus, mnemonic z= spelling lookup
  " Alternative to nnoremap z- viwA<C-x><C-t>
  nnoremap z- :call Suggest(thesaurus, expand('<cword>'))<CR>
  " go - fuzzy find file
  nnoremap go :FZF<CR>
  " quick edit and reload for fast iteration. Credit http://howivim.com/2016/damian-conway
  nnoremap <SPACE>v :edit ~/dotfiles/softlinks/.vimrc<CR>
  autocmd BufWritePost ~/dotfiles/softlinks/.vimrc source ~/dotfiles/softlinks/.vimrc
  " quick edit plugins
  nnoremap <SPACE>V :edit ~/.vim/plugged<CR>
  " go to zshrc
  nnoremap <SPACE>z :edit ~/dotfiles/softlinks/.zshrc<CR>
  " scratchpad, review the plan
  nnoremap <SPACE>s :call <SID>OpenScratch()<CR>
  " scratchpad, taking notes on the current file path
  nnoremap <SPACE>S
    \ :call <SID>OpenScratch()<CR>
    \ Go<C-r># = 
  " space - read/write clipboard
  nnoremap <SPACE> "+
  " visual space - read/write clipboard
  vnoremap <SPACE> "+
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
  " find selected word, or word under cursor
  nnoremap <C-f> :silent Ggrep <cword><CR>
  vnoremap <C-f> y:silent Ggrep "<C-r>0"<CR>zz
  " find but but leave open for editing
  nnoremap f<C-f> yiw:Ggrep "<C-r>0"<LEFT>
  vnoremap f<C-f> y:Ggrep "<C-r>0"<LEFT>
  " visual interactive align - vip<Enter>
  vnoremap <Enter> <Plug>(EasyAlign)
  " interactive align text object - ==ip, clobbers equalprg single line
  nnoremap == <Plug>(EasyAlign)
  " enhancement - <C-w>n splits are vertical
  nnoremap <C-w>n :vert new<CR>
  " enhancement - next search centers page
  nnoremap n nzz
  " enhancement - reverse search centers page
  nnoremap N Nzz
  " insert timestamp in command and insert mode
  noremap! <C-t> <C-r>=Now()<CR>
  " insert datestamp in command and insert mode
  noremap! <C-d> <C-r>=Today()<CR>
  " w!! saves as sudo
  cnoremap w!! w !sudo tee > /dev/null %
  " focus - close all buffers but the current one
  command! Focus wa|%bd|e#
  " Toggle quickfix
  nnoremap <expr> yoq IsQuickfixClosed() ? ':copen<CR>:resize 10%<CR>' : ':cclose<CR>'
  " enhancement - pasting over a visual selection keeps content
  vnoremap <silent> <expr> p <sid>VisualPut()
  " <space><space> toggles markdown checkboxes
  autocmd filetype markdown nnoremap <buffer> <SPACE><SPACE> :call <SID>ToggleCheckbox()<CR>
augroup END

augroup vimrc/functions | autocmd!
  " ==[ Functions ]=================================================================================
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

  function! PositionCursor()
    let cursor_exceptions = ['qf', 'loc', 'fugitive', 'gitcommit', 'gitrebase']
    if index(cursor_exceptions, &filetype) == -1 && line("'\"") <= line('$')
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

  " Experimental thesaurus lookup
  " FIXME: This works, but there's a bug to squash
  " SyntaxError - E492: Not an editor command: <selected_word> (see vim-jp/vim-vimlparser)
  let thesaurus = {}
  for line in readfile(&thesaurus)
    let parts = split(line, ',')
    let [word, synonyms] = [parts[0], parts[1:]]
    let thesaurus[word] = synonyms
  endfor
  function! Suggest(thesaurus, word)
    let synonyms = a:thesaurus[a:word][:&lines - 2]
    let synonyms = map(synonyms, { i, synonym -> (i+1) . '. ' . synonym })
    let choice = inputlist(synonyms)
    let replace = a:thesaurus[a:word][choice-1]
    echo "\nYou selected " . replace
    execute 'normal! ciw' . replace
  endfunction

  function! s:QuickfixChangelist()
    call s:TrackDefaultBranch()

    let conflict_check = FugitiveExecute('ls-files', '--unmerged')
    let wip_check = FugitiveExecute('diff-index', 'HEAD', '--')
    if !empty(conflict_check['stdout'][0])
      echo 'Conflict changes for ' . conflict_check['git_dir']
      Git mergetool
    elseif !empty(wip_check['stdout'][0])
      echo 'Uncommited changes for ' . wip_check['git_dir']
      Git difftool
    else
      echo 'Commited changes for ' . wip_check['git_dir']
      exec ':Git difftool ' . systemlist('git merge-base origin/HEAD HEAD')[0]
    endif
  endfunction

  function! s:DiffBuffer()
    call s:TrackDefaultBranch()

    let wip_check = FugitiveExecute('diff-index', 'HEAD', '--')
    if !empty(wip_check['stdout'][0])
      Gdiffsplit
    else
      exec ':Gdiffsplit ' . systemlist('git merge-base origin/HEAD HEAD')[0]
    endif
  endfunction

  function! Now()
    return strftime('%Y-%m-%dT%T%z') " cheetsheet: https://strftime.org/
  endfunction

  function! Today()
    return strftime('%Y-%m-%d %A') " cheetsheet: https://strftime.org/
  endfunction

  function! s:TrackDefaultBranch()
    let remote_check = FugitiveExecute('show-ref', 'origin/HEAD')
    if remote_check['exit_status'] != 0
      echo 'Setting up origin/HEAD'
      call FugitiveExecute('remote', 'set-head', 'origin', '--auto')
    endif
  endfunction

  " TODO: Bullet journal.
  " Template Year, Month, week
  " Link between them, isolate into folders
  " Create new filetype
  " Checkboxes change to complete with <ENTER>
  " Migration with <LEFT> and <RIGHT> arrows
  function! Weekdays()
    let format = '%Y-%m-%d %A' " cheetsheet: https://strftime.org/
    let days_since_monday = strftime('%w') - 1
    let as_seconds = 24 * 60 * 60
    let monday_epoc = localtime() - days_since_monday * as_seconds
    let weekdays = map(range(0,6), { i -> strftime(format, monday_epoc + i * as_seconds) })
    return weekdays
  endfunction

  function! s:ConditionalSyntaxDisable()
    let bytes_per_megabyte = pow(10, 6)
    let megs = line2byte(line('$') + 1) / bytes_per_megabyte
    if megs > 5
      echo printf('%.2fmb chonky file threshold: syntax off, manual folds', megs)
      syntax clear
      setlocal foldmethod=manual
    endif
  endfunction

  function! s:OpenScratch()
    let week_of_the_year = strftime('%Y-wk%W')
    let scratch_path = '~/Desktop/scratch-' . week_of_the_year . '.md'
    execute ':edit ' . scratch_path
  endfunction

  function! s:ToggleCheckbox()
    let line = getline('.')
    let checked = '- [x]'
    let unchecked = '- [ ]'
    if line =~# ('\V' . checked)
      let toggled = substitute(line, '\V' . checked, unchecked, '')
      call setline('.', toggled)
    elseif line =~# ('\V' . unchecked)
      let toggled = substitute(line, '\V' . unchecked, checked, '')
      call setline('.', toggled)
    end
  endfunction
augroup END
