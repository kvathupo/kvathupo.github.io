"
"--------------------------------------
" Settings for Vim
"--------------------------------------
"
" Requires: Vim 8
" Repo: https://github.com/vim/vim.git
"

" -> Set tab to 2 spaces <-
function! TabSmall()
    set tabstop=2
    set shiftwidth=2
    set softtabstop=2
    set expandtab
endfunction
" -> general <-
set t_Co=256
set ruler
set hlsearch
set tabpagemax=15
set formatoptions+=r
syntax on
" -> tabs <-
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

"
"--------------------------------------
" Settings for Github plugins
"--------------------------------------
"
" -> morhetz/gruvbox <-
" -> https://github.com/morhetz/gruvbox.git
colorscheme gruvbox
set background=dark
let g:gruvbox_bold=1
let g:gruvbox_italic=1
let g:gruvbox_termcolors=256

" -> plasticboy/vim-markdown <-
" -> https://github.com/plasticboy/vim-markdown.git
let g:vim_markdown_folding_disabled = 1

" -> leafgarland/typescript-vim <-
" -> https://github.com/leafgarland/typescript-vim.git
let g:typescript_indent_disable = 1
