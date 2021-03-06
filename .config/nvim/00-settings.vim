" Base settings {{{
" Tell neovim to use true colors (version 0.1.3-0.1.4)
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" Neovim true color support for version >= 0.1.5
if (has("termguicolors"))
    set termguicolors
endif

set encoding=utf-8

set autoindent
set noautochdir
set backspace=start,indent,eol

set list
set listchars=tab:▸\ ,eol:↲,extends:»,precedes:«,trail:·
set showbreak=↪

set relativenumber
set number
set cursorline
set incsearch
set hlsearch
set ignorecase
set smartcase

set laststatus=2

set formatoptions+=j " Merge comments properly

set hidden
set textwidth=79

set grepprg=grep\ -n\ $@

set completeopt=menuone

set colorcolumn=+1
set background=dark
" }}}

" Tab settings {{{
set scrolloff=3
set expandtab
set tabstop=4
set shiftwidth=4
set smarttab
" }}}

" Wildmenu completion {{{
set wildmenu
set wildmode=list:longest,full
set wildignore+=.git
set wildignore+=*.pyc
set wildignore+=*.DS_Store " OSX crap
" }}}

" Folding {{{
set foldlevelstart=0
" }}}

" Backup options {{{
set backup
set writebackup

set history=500

set undofile
set undolevels=512
" }}}
