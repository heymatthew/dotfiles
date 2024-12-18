" Use .vimrc for config
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" autocmd Filetype ruby silent !gem list -i ruby-lsp-rails > /dev/null || gem install ruby-lsp-rails

lua << LSP_SETUP
LSP_SETUP
