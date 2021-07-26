" if we're using fish, switch the shell to bash for posix compat
if &shell =~# 'fish$'
  set shell=bash
endif

call plug#begin('~/.config/nvim/plugged')
" Theme-related plugins
Plug 'fenetikm/falcon'
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'

" Linting
Plug 'w0rp/ale'

" EditorConfig
Plug 'editorconfig/editorconfig-vim'

" File Explorer
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-eunuch'

" Comments
Plug 'preservim/nerdcommenter'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'shime/vim-livedown', { 'do': 'npm install -g livedown' }
Plug 'jiangmiao/auto-pairs'
Plug 'nathanaelkane/vim-indent-guides'

" Language Plugins
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'hashivim/vim-terraform'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'jparise/vim-graphql'
Plug 'dag/vim-fish'
Plug 'rust-lang/rust.vim'
Plug 'ron-rs/ron.vim'
Plug 'elixir-editors/vim-elixir'
Plug 'mhinz/vim-mix-format'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'cespare/vim-toml'

" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release','do': 'yarn install --frozen-lockfile'}
Plug 'OmniSharp/omnisharp-vim'

" Docs
Plug 'rizzatti/dash.vim'

" REST Client
Plug 'diepm/vim-rest-console'

" TMUX integration
Plug 'christoomey/vim-tmux-navigator'

call plug#end()

set autoread

" Files and such
filetype plugin on
filetype indent on

set nobackup
set nowb
set noswapfile

set encoding=utf8

set nowrap
set formatoptions-=tc

" Theme/Display Configuration
syntax on
silent! colorscheme onedark
set background=dark
set termguicolors
set noshowmode
set noruler
set noshowcmd

set colorcolumn=80

let g:onedark_lightline = 1
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
  \   'right': [ [ 'filetype' ] ]
  \ },
  \ 'inactive': {
  \   'left': [['filename']],
  \   'right': [['filetype']]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head'
  \ },
  \ }

" Open new windows to the right/below
set splitright
set splitbelow

" Use system clipboard
set clipboard=unnamed

set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/node_modules/*,*.class

" NerdTree Configuration
let NERDTreeShowHidden=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" ctrl-p config
let g:ctrlp_show_hidden = 1

" Key Mapping things
let mapleader = ","

" Speedy window switching
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

nmap <leader>so :source ~/.config/nvim/init.vim<cr>
nmap <leader>w :w<cr>
nmap <leader>nt :NERDTree<cr>
nmap <leader>ntf :NERDTreeFocus<cr>
nmap <leader>md :LivedownPreview<cr>
nmap <leader>cr :CocRestart<cr>

nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" Because I fat-finger :W instead of :w all the time
command! W w

" Fix coc-nvim scrolling
" Remap <C-f> and <C-b> for scroll float windows/popups.
nnoremap <expr><C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <expr><C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <expr><C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<Right>"
inoremap <expr><C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<Left>"

" Autocomplete Settings
set updatetime=250
set completeopt+=noinsert
set completeopt+=noselect
set completeopt-=preview

" Path to python interpreter for neovim
let g:python3_host_prog = '/usr/local/bin/python3'
" Skip the check of neovim module
let g:python3_host_skip_check = 1

let g:deoplete#enable_at_startup = 1

" Go settings
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_fmt_command = "gopls"
let g:go_fmt_experimental = 1
let g:go_gocode_autobuild = 0 "disable vim-go autocompletion
let g:go_addtags_transform = "camelcase"
let g:go_list_type = 'locationlist'
nmap <leader>gt :GoTest<cr>
nmap <leader>j :lnext<cr>
nmap <leader>k :lprevious<cr>

" Terraform Settings
autocmd BufWritePost *.tf if &filetype == "terraform" | exec 'TerraformFmt' | endif

let g:terraform_fold_sections=1

" Omnisharp
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_server_use_mono = 1

" Elixir
let g:mix_format_on_save = 1
let g:mix_format_silent_errors = 1

" ALE
let g:ale_linters = {
\ 'cs': ['OmniSharp']
\}

" Rust
let g:rustfmt_autosave = 1

" EJS Syntax View
autocmd BufNewFile,BufRead *.ejs set filetype=html

" SQL
let g:omni_sql_no_default_maps = 1

" CoC Extensions
let g:coc_global_extensions = [
  \ 'coc-marketplace',
  \ 'coc-tsserver',
  \ 'coc-rls',
  \ 'coc-json',
  \ 'coc-go',
  \ 'coc-elixir',
  \ 'coc-ember'
\ ]
