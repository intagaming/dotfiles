call plug#begin()
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-airline/vim-airline'
Plug 'ap/vim-css-color'
call plug#end()

colorscheme dracula


syntax on

set tabstop=4
set softtabstop=4
set expandtab
set number
set relativenumber
set showcmd
set ruler
set shiftwidth=4
set updatetime=100

" Cursor line highlight
set cursorline

" Filetype detection
filetype indent on
filetype plugin indent on

set wildmenu
set lazyredraw
set showmatch
set incsearch
set hlsearch

let mapleader=","

nnoremap <leader><space> :nohlsearch<CR>

" dwmblocks
autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid dwmblocks & }

" Use persistent history.
if !isdirectory("/tmp/.vim-undo-dir")
    call mkdir("/tmp/.vim-undo-dir", "", 0700)
endif
set undodir=/tmp/.vim-undo-dir
set undofile

" last-position-jump: remember last pos
:au BufReadPost *
   \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
   \ |   exe "normal! g`\""
   \ | endif
