" basic
set number
set relativenumber
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

" tab
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=4
set backspace=indent,eol,start

" file
set autowrite autoread
set nobackup noswapfile

" syntax
syntax on
filetype plugin indent on
set t_Co=256

" italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

" highlight current line
set cursorline
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
" https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
highlight CursorLine guibg=#444444 ctermbg=238

" menu
set completeopt=noinsert,menuone,noselect
set wildmenu
" https://vi.stackexchange.com/a/12665
highlight Pmenu ctermbg=gray guibg=gray

" others
set clipboard=unnamedplus
set hidden
set splitbelow splitright
set title
set ttimeoutlen=0
set scrolloff=5
