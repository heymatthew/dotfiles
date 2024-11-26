scriptencoding utf8

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
    Plug 'heymatthew/vim-wordsmith'        " Thesaurus, etc.
    Plug 'junegunn/fzf',  { 'dir': '~/forge/fzf', 'do': 'yes \| ./install' }
    Plug 'preservim/vim-textobj-sentence'  " Extend native sentence objects and motions
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
    Plug 'vim-scripts/SyntaxAttr.vim'      " Display syntax highlighting attributes under cursor

    " FIXME: Spams with escape codes on vim startup
    " i.e. ^[[3;1R^[[>41;2500;0c^[]10;rgb:5679/527d/76aa^[\^[]11;rgb:f9eb/f528/eeac^[\
    " Plug 'tpope/vim-bundler'               " :Bundle hooks, also path and tags include bundled gems
  call plug#end()
augroup END

augroup vimrc/settings | autocmd!
  " ==[ Settings ]==================================================================================
  " Setting principles (WIP)
  " 1. Interface minimalism
  " 2. Portability over monolythic
  " 3. Experimentation over stability

  set scrolloff=999                " Center cursor by default
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
  set foldminlines=1               " Folds only operate on blocks more than 1 lines long
  set nrformats-=octal             " Disable octal increment from <C-a>, i.e. 007 -> 010
  set diffopt+=algorithm:histogram " Format diffs with histogram algo
                                   " https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
  set cdpath+=~/forge              " cd can resolve files under ~/forge
  set mouse=                       " turn off mouse

  let g:fzf_preview_window = []             " disable fzf preview window
  let g:ale_set_highlights = 0              " remove highlights
  let g:ale_set_loclist = 0                 " don't clobber location list
  let g:ale_set_quickfix = 0                " don't clobber quickfix list
  let g:ale_virtualtext_cursor = 'disabled' " don't show virtual text with errors
  let g:golden_ratio_autocommand = 0        " disable golden ratio by default
  let g:fugitive_legacy_commands = 0        " don't populate deprecated fugitive commands

  colorscheme blinkenlights

  " Prefer splitting down or right
  set splitright   " vertical windows go right
  set splitbelow   " horizontal windows go below
  autocmd FileType help wincmd L

  " Whitespace management
  set                                 expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype markdown  setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype go        setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype perl      setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype ruby      setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype sh        setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype julia     setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype gitconfig setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype html      setlocal expandtab   tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype eruby     setlocal expandtab   tabstop=2 softtabstop=2 shiftwidth=2
  autocmd Filetype lua       setlocal expandtab   tabstop=3 softtabstop=3 shiftwidth=3
  " https://github.com/luarocks/lua-style-guide?tab=readme-ov-file#indentation-and-formatting

  " Writing Prose
  set spelllang=en_nz
  set dictionary=/usr/share/dict/words
  " markdown complete ignores case for matches but uses the context
  autocmd Filetype markdown setlocal ignorecase infercase
  " wraped words have the same indent as prevoius line
  autocmd Filetype markdown setlocal breakindent

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
    " FIXME: Disabled for now. Understand this error before turning back on:
    " Error detected while processing BufRead Autocommands for "*.md"..FileType Autocommands for "markdown"..function textobj#sentence#init:
    " line 73: E117: Unknown function: textobj#user#plugin
    " autocmd FileType markdown call textobj#sentence#init()
    " autocmd FileType text call textobj#sentence#init()

    let g:dispatch_compilers = { 'be rspec' : 'rspec' ,
                               \ 'be': 'ruby',
                               \ 'be rubocop': 'ruby' }
  end

  " Debugging reminders
  autocmd FileType ruby :iabbrev <buffer> puts puts<ESC>m`A # FIXME: commit = death<ESC>``a
  autocmd FileType ruby :iabbrev <buffer> binding binding<ESC>m`A # FIXME: commit = death<ESC>``a

  " Common Abbreviations
  autocmd FileType gitcommit :iabbrev <buffer> prr Preparatory Refactoring
  cabbrev prr preparatory-refactoring

  " Set foldmethod but expand all when opening files
  set foldmethod=syntax
  autocmd BufRead * normal zR
  autocmd Filetype fugitive   setlocal foldmethod=manual
  autocmd Filetype haml       setlocal foldmethod=indent
  autocmd Filetype sh         setlocal foldmethod=indent
  autocmd Filetype eruby.yaml setlocal foldmethod=indent
  autocmd Filetype yaml       setlocal foldmethod=indent
  autocmd Filetype eruby      setlocal foldmethod=indent
  autocmd Filetype markdown   setlocal foldmethod=manual

  let indent_fold = 'setlocal foldmethod=indent'
  autocmd Filetype vim exec indent_fold
  autocmd filetype vim exec printf('autocmd! SourcePost %s %s', expand('%'), indent_fold)

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
  " open location/quickfix after :make, :grep, :lvimgrep and friends
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    cwindow

  " FIXME: use pipe_tables https://pandoc.org/chunkedhtml-demo/8.9-tables.html
  autocmd FileType markdown setlocal formatprg=pandoc\ --from\ markdown\ --to\ markdown
  autocmd Filetype ruby     setlocal keywordprg=ri       " Lookup docs with ri
  autocmd FileType json     setlocal formatprg=jq        " Format json files with jq
  autocmd FileType sql      setlocal formatprg=pg_format " Format json files with jq
  autocmd Filetype markdown setlocal keywordprg=define " custom command, OSX dictionary

  " See https://vim.fandom.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
  " restore cursor position on file open
  autocmd BufWinEnter * call PositionCursor()

  " Terminal enters insert mode automatically
  autocmd WinEnter term://* startinsert
  autocmd WinLeave term://* stopinsert

  " FIXME: WezTerm makes you choose zsh or vim to set title
  " Find a way to make this work for both
  autocmd VimEnter,WinEnter,DirChanged * :set title | let &titlestring = 'Σ v:' . NicePwd()
  autocmd WinEnter term://* setlocal statusline=%{b:term_title}

  " Deprecations and Habit Changes
  " highlight HabitChange guifg=love cterm=underline
  " match HabitChange /recieve/
  " match HabitChange /recieve_message_chain/

  if has('nvim')
    autocmd Filetype ruby call StartRubyLSP()

    " FIXME: It looks like some of this is working in rails projects, however
    " it looks like refactor rename (grr), refactor actions (gra),
    " and find references (grr) are not. Figure out if this is unsupported by
    " the plugin and iterate.
    " Plugin: https://github.com/Shopify/ruby-lsp
    function! StartRubyLSP()
      !gem list -i ruby-lsp > /dev/null || gem install ruby-lsp
      lua vim.lsp.start({ name = 'ruby-language-server', cmd = {'ruby-lsp'} })
    endfunction
  endif
augroup END

augroup vimrc/mappings | autocmd!
  " ==[ Custom Mappings ]===========================================================================
  " Mapping Principles (WIP)
  " 1. Trial native vim before mapping
  " 2. Consistency: Rif off existing mnemonics
  " 3. Common usage: use chords, single or two key mnemonics

  " enhancement - <C-w>n splits are vertical
  nnoremap <C-w>n :vert new<CR>
  " enhancement - pasting over a visual selection keeps content
  vnoremap <silent> <expr> p <sid>VisualPut()
  " enhancement - gf opens files that don't exist
  autocmd filetype markdown nnoremap <buffer> gf :e <cfile><CR>
  " enhancements - <C-w>f opens files that don't exist
  nnoremap <C-w>f :vertical split <cfile><CR>
  " enhancement - zz toggles center cursor, zt and zb reset
  nnoremap zz :let &scrolloff = (&scrolloff == 999 ? 5 : 999)<CR>
  nnoremap zb :set scrolloff=5<CR>zb
  nnoremap zt :set scrolloff=5<CR>zt

  " git command
  nnoremap g<SPACE> :Git 
  " git status
  nnoremap gs :Git<CR>
  " git log
  nnoremap gl :Git log --oneline -100<CR>
  " git log, new tab
  nnoremap gL :tab Git log --oneline -100<CR>
  " git blame
  nnoremap gb :Git blame<CR>
  " git blame with copy paste detection, ignoring whitespace
  nnoremap gB :Git blame -C -M -w<CR>
  " gx opens commits in github for git, fugitive, and blame windows
  autocmd filetype git*,fugitive* nnoremap <buffer> gx :GBrowse <cword><CR>
  " dp runs git push (diff put)
  autocmd filetype fugitive nnoremap <buffer> dp :Git push<CR>
  " do runs git pull (diff obtain)
  autocmd filetype fugitive nnoremap <buffer> do :Git pull<CR>
  " find merges from a blame window
  autocmd filetype fugitiveblame nmap <buffer> m
    \ :call <SID>TrackDefaultBranch()<CR>
    \ :Git log <cword>..origin/head --ancestry-path --merges --reverse<CR>
  " find merges in a new tab (varient of m above)
  autocmd filetype fugitiveblame nmap <buffer> M
    \ :call <SID>TrackDefaultBranch()<CR>
    \ :tab Git log <cword>..origin/head --ancestry-path --merges --reverse<CR>
  " changes (gC) - quickfix jumplist of hunks since branching
  nnoremap gC :call <SID>QuickfixChangelist()<CR>
  " diff changes (dC)
  nnoremap dc :call <SID>DiffBuffer()<CR>
  " close fugitive diffs
  nnoremap dq :call fugitive#DiffClose()<CR>
  " edit commit template
  autocmd filetype fugitive nmap <buffer> ct
    \ :!cp ~/.gitmessage ~/.gitmessage.bak<CR>
    \ :edit ~/.gitmessage<CR>
    \ Go<C-r>=GitHumans()<CR>
    \ <ESC>gg
  " <C-l> refreshes git pane, like netrw refresh
  autocmd filetype fugitive nnoremap <buffer> <C-l> :Git<CR><C-l>
  " open github commands
  autocmd filetype fugitive nnoremap <buffer> gh<SPACE> :Git hub 
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
  " go - fuzzy find file
  nnoremap go :Files<CR>
  " gO - fuzzy find previously opened files
  nnoremap gO :History<CR>
  " quick edit and reload for fast iteration. Credit http://howivim.com/2016/damian-conway
  nnoremap <SPACE>v :call ConfigureVim()<CR>
  autocmd BufWritePost .vimrc nested source %
  autocmd BufWritePost ~/.vim/plugged/**/*.vim nested source %
  " quick edit plugins
  nnoremap <SPACE>V :edit ~/.vim/plugged<CR>
  " quick edit blinkenlights
  nnoremap <SPACE>b :edit ~/.vim/plugged/vim-blinkenlights/colors/blinkenlights.vim<CR>
  " go to zshrc
  nnoremap <SPACE>z :edit ~/dotfiles/softlinks/.zshrc<CR>
  " scratchpad, review the plan
  nnoremap <SPACE>s :call <SID>OpenScratch()<CR>
  " scratchpad, taking notes on the current file path
  nnoremap <SPACE>S
    \ :let interesting_file = expand('%') . ':' . line('.')<CR>
    \ :call <SID>OpenScratch()<CR>
    \ Go\| <C-r>=interesting_file<CR> \|  \|<LEFT><LEFT>
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
  " Clear serach highlights, quickfix, and friends.
  " note, it looks like :noh does not work within a vimscript function
  nnoremap <expr> <BACKSPACE> JustHappened('BACKSPACE') ? ':call CloseHelperWindows()<CR>' : ':noh<CR>'
  " nnoremap <BACKSPACE> :call Noh()<CR>
  " find selected word, or word under cursor
  nnoremap <C-f> :silent Ggrep <cword><CR>
  vnoremap <C-f> y:silent Ggrep "<C-r>0"<CR>
  " find but but leave open for editing
  nnoremap f<C-f> yiw:Ggrep "<C-r>0"<LEFT>
  vnoremap f<C-f> y:Ggrep "<C-r>0"<LEFT>
  " interactive align text object -, clobbers :equalprg
  nnoremap = <Plug>(EasyAlign)
  " let == go through to :equalprg so you can still align stuff
  nnoremap == =
  " w!! saves as sudo
  cnoremap w!! w !sudo tee > /dev/null %
  " Focus - close all buffers but the current one
  command! Focus wa|%bd|e#
  " Merges - find what merged to mainline for a ref under cursor
  command! Merges Git log <cword>..origin/head --ancestry-path --merges --reverse
  " Toggle quickfix
  nnoremap <expr> yoq IsQuickfixClosed() ? ':copen<CR>:resize 10%<CR>' : ':cclose<CR>'
  " <enter> toggles markdown checkboxes
  autocmd filetype markdown nnoremap <buffer> <ENTER> :call <SID>MarkdownToggleCheckbox()<CR>
  " Insert <enter> continues checkboxes
  autocmd filetype markdown inoremap <buffer> <CR> <CR><C-r>=<SID>DeriveListFromAbove()<CR>
  " o continues lists below
  autocmd filetype markdown nnoremap <buffer> o o<C-r>=<SID>DeriveListFromAbove()<CR>
  " O continues lists above
  autocmd filetype markdown nnoremap <buffer> O O<C-r>=<SID>DeriveListFromBelow()<CR>

  " Prefer vertical splits
  nnoremap <C-w>f :vertical wincmd f<CR>
  nnoremap <C-w>d :vertical wincmd d<CR>
  nnoremap <C-w>] :vertical wincmd ]<CR>
  nnoremap <C-w>^ :vertical wincmd ^<CR>
  nnoremap <C-w>F :vertical wincmd F<CR>

  " CTRL Escape will leave insert mode in terminal
  tnoremap <C-ESC> <C-\><C-N>
  " Ctrl + w actions in terminal windows
  tnoremap <C-w> <C-\><C-N><C-w>

  " Tripple star (***) is shorthand for non greedy search
  cnoremap *** \{-}
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
    return strftime('%Y-%m-%d') " cheetsheet: https://strftime.org/
  endfunction

  function! DayOfTheWeek()
    return strftime('%A') " cheetsheet: https://strftime.org/
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
    let scratch_path = '~/Documents/scratch-' . week_of_the_year . '.md'
    execute ':edit ' . scratch_path
  endfunction

  function! s:MarkdownToggleCheckbox()
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

  function! s:DeriveListFromAbove()
    let line_above = getline(line('.') - 1)
    return ListTokenFrom(line_above)
  endfunction

  function! s:DeriveListFromBelow()
    let line_below = getline(line('.') + 1)
    return ListTokenFrom(line_below)
  endfunction

  function! ListTokenFrom(adjacent_line)
    if &paste
      return ''
    endif

    if a:adjacent_line =~# '^\s*- \[.\]' " Checklist
      return '- [ ] '
    elseif a:adjacent_line =~# '^\s*-'
      return '- '
    elseif a:adjacent_line =~# '^\s*\*'
      return '* '
    elseif a:adjacent_line =~# '^\s*>'
      return '> '
    end

    let numbered = matchlist(a:adjacent_line, '\v^\s*(\d+)\.')
    echo numbered
    if len(numbered) > 0 " Numbering (42.)
      let n = str2nr(numbered[1])
      return printf('%d. ', n+1)
    endif

    return ''
  endfunction

  function! NicePwd()
    let pwd = systemlist('pwd')[0]
    return substitute(pwd, $HOME, '~', '')
  endfunction

  function! ConfigureVim()
    if expand('%:t') ==# '.vimrc'
      edit ~/dotfiles/softlinks/.config/nvim/init.vim
    else
      edit ~/dotfiles/softlinks/.vimrc
    endif
  endfunction

  let s:just_happened_lookup = {}
  function! JustHappened(context)
    let this_run = strftime('%s')
    let last_run = get(s:just_happened_lookup, a:context, 0)
    let elapsed_time = this_run - last_run
    let s:just_happened_lookup[a:context] = this_run
    return elapsed_time < 2 " seconds
  endfunction

  function! CloseHelperWindows()
    " Git pane
    try | bdelete : | catch | endtry

    " Quickfix, location list, and preview windows
    cclose
    lclose
    pclose
  endfunction
augroup END
