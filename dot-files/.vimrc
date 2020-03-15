" -> functions <-
" Set tabs to 2 spaces
function! TabSmall()
    set tabstop=2
    set shiftwidth=2
    set softtabstop=2
    set expandtab
endfunction
" -> general <-
set t_Co=256
set ruler
syntax on
" -> tabs <-
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
" -> gruvbox <-
colorscheme gruvbox
set background=dark
let g:gruvbox_bold=1
let g:gruvbox_italic=1
let g:gruvbox_termcolors=256
