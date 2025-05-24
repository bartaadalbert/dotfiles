" ~/.vimrc

" Basic settings
set nocompatible
set number
set relativenumber
set ruler
set showcmd
set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase
set autoindent
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set wrap
set textwidth=80
set colorcolumn=80

" Enable syntax highlighting
syntax enable
filetype plugin indent on

" Color scheme
colorscheme desert

" Better backspace behavior
set backspace=indent,eol,start

" Show whitespace
set listchars=tab:>·,trail:·,extends:>,precedes:<
set list

" Split settings
set splitbelow
set splitright

" Disable swap files
set noswapfile
set nobackup
set nowritebackup

" Better search behavior
set wildmenu
set wildmode=list:longest,full

" Key mappings
let mapleader = " "

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" Clear search highlighting
nnoremap <leader>/ :nohlsearch<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Tab navigation
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <leader>tc :tabclose<CR>

" Better indentation
vnoremap < <gv
vnoremap > >gv

" Quick edit vimrc
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Status line
set laststatus=2
set statusline=%f\ %h%w%m%r\ %=%(%l,%c%V\ %=\ %P%)
