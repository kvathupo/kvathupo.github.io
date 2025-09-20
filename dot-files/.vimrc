"
"--------------------------------------
" Settings for Vim
"--------------------------------------
"
" Requires: Vim 8
" Repo: https://github.com/vim/vim.git
"
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8

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
" -> C++ highlighting support for modules <-
autocmd BufNewFile,BufRead *.cpp,*.hpp,*.cxx,*.hxx,*.cc,*.hh,*.ixx setlocal filetype=cpp

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

" -> editorconfig/editorconfig-vim <-
" -> https://github.com/editorconfig/editorconfig-vim.git <-
" Set as a vim 8 startup package
