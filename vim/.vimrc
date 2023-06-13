" we want Vim, not Vi
set nocompatible

" syntax not supported by vim-tiny
" syntax on
" filetype plugin indent on

" indent
set autoindent
set expandtab
set softtabstop=4
set shiftwidth=4
set shiftround

" line numbers are too wide in vim-tiny
" set number
" set relativenumber
" set numberwidth=4

" encoding
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

" backspace
set backspace=indent,eol,start

" statusline
set laststatus=2

" show current mode
set showmode
set showcmd

" highlight search
set hlsearch
set incsearch

" render
set ttyfast
set lazyredraw

" backup
set autowrite
set autoread
set nobackup
set noswapfile

" window
set splitbelow
set splitright

" misc
set hidden
set display=lastline
set cursorline
set wrapscan
set report=0
set title
set ttimeoutlen=0
set scrolloff=5
