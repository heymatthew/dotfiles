" Quick iteration on nvim config, credit http://howivim.com/2016/damian-conway
nmap <leader>v :edit $MYVIMRC<CR>
autocmd! BufWritePost $MYVIMRC source $MYVIMRC

let plug_path = stdpath('data') . '/autoload/plug.vim'
if !filereadable(plug_path)
  echom 'Installing plug...'
  execute '!curl -fLo ' .. plug_path .. ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  source $MYVIMRC
  finish
endif

" Window resize sets equal splits https://hachyderm.io/@tpope/109784416506853805
autocmd! VimResized * wincmd =
