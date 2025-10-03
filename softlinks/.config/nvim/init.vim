" Use .vimrc for config
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua << LSP_SETUP
LSP_SETUP
