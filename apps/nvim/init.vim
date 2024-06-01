
"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')
"Plug 'psf/black', { 'branch': 'stable' }
call plug#end()

" Change Leader and LocalLeader keys:
let maplocalleader = ','
let mapleader = ';'

filetype plugin indent on
set autoindent

set backupdir=/tmp
set nocompatible

" Performances
set synmaxcol=200
let did_install_default_menus=1
set lazyredraw

" Coloration syntaxique
syntax on
" colorscheme gruvbox
set background=dark

" Aides visuelles
set ruler
set showcmd
set number relativenumber
set mouse=

" Recherche incrémentale
" set hlsearch
set incsearch
set ignorecase
set smartcase

if has ('nvim')
    set inccommand=nosplit
endif

set tabstop=4
set shiftwidth=4
set softtabstop=0
set noexpandtab
set smarttab
set autoindent
set preserveindent
set copyindent
set fileformat=unix

set path+=**
set wildmenu
set wildmode=longest,full

set clipboard+=unnamedplus
set t_Co=256
set encoding=utf8
set linespace=0
set hidden

" Folding
set foldmethod=indent
set foldlevel=99

" Text Wraping
"set textwidth=79
set colorcolumn=90
set wrap
set scrolloff=5

" netrw
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3

"jk to escape
inoremap jk <esc>:noh<return><esc>

"Split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <esc> :noh<return><esc>
nnoremap gf :e <cfile><cr>
"nnoremap <c-w> :sp <cfile><cr>
nnoremap g<CR> g<C-]>
nnoremap <C-]> g<C-]>

"nnoremap <leader>p :History<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>t :Files<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <leader>c :Commands<CR>
nnoremap <leader>k :bdelete<CR>
nnoremap <leader>g :Goyo<CR>
"nnoremap <leader>d :Codi<CR>
nnoremap <leader>x :Lines<CR>
nnoremap <leader>v :BLines<CR>
nnoremap <leader>w :w<CR>
inoremap <leader>w <C-c>:w<CR>
nmap <leader>l :TagbarToggle<CR>
nmap <F8> :TagbarToggle<CR>
"nnoremap <BS> <PageUp>
"nnoremap <Space> <PageDown>
"nnoremap <leader>n :lnext<CR>
"nnoremap <leader>p :lprev<CR>

" Source fichiers de conf à la modification
augroup configurationFiles
  autocmd! BufWritePost init.vim      source %
augroup END

" Airline
"set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='minimalist'

if !exists('g:airline_symbols')
	    let g:airline_symbols = {}
    endif

    " unicode symbols
	let g:airline_left_sep = '»'
	let g:airline_left_sep = '▶'
	let g:airline_right_sep = '«'
	let g:airline_right_sep = '◀'
	let g:airline_symbols.linenr = '␊'
	let g:airline_symbols.linenr = '␤'
	let g:airline_symbols.linenr = '¶'
	let g:airline_symbols.branch = '⎇'
	let g:airline_symbols.paste = 'ρ'
	let g:airline_symbols.paste = 'Þ'
	let g:airline_symbols.paste = '∥'
	let g:airline_symbols.whitespace = 'Ξ'

   " airline symbols
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
	let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''

"Python
"autocmd BufWritePre *.py execute ':Black'
let g:ale_linters = {'python': ['ruff']}
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:deoplete#enable_at_startup = 1
