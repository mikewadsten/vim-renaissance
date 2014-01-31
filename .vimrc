" vim-renaissance .vimrc
" almost totally inspired by Learn Vimscript the Hard Way exercises

" pretty colors
colorscheme zellner

"echo ">^.^<"

set number "show line numbers
set shiftround shiftwidth=4 "auto indent 4

" easy line movement
" up... (+ requires shift but = doesn't work)
nnoremap + ddkP
" and down
nnoremap - ddp

" ctrl-u to uppercase the current word when in normal mode
" mark (k), upper case the word, go back to (k)
nnoremap <c-u> mkviwU<esc>`k

" leader mapping(s)
let mapleader = ','
let localleader = "\\"

" don't wrap lines around
set nowrap

" easy vimrc editing
nnoremap <leader>ev :split $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR> :echo "Reloaded configuration from" expand("$MYVIMRC") <CR>

" auto correct ftw
iabbrev adn and
iabbrev th the
" doesn't tpope have a plugin for this? abolish?

" strong h and l movement
nnoremap H 0
nnoremap L $

" because Escape is way the fuck over there
inoremap jk <esc>
" let's learn this shit the hard way
inoremap <esc> <nop>
" while we're at it, let's keep the arrows disabled
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" at this point i'm missing out on these mappings
" delete to black hole register (can't paste it back in)
nnoremap <leader>d "_dd
vnoremap <leader>d "_dd
" screw you, shift key
nnoremap ; :

" fun little abbreviations
" yeah, I'll probably dig into using a snippets manager later
autocmd FileType python		:iabbrev <buffer> iff if:<left>
autocmd FileType python		:iabbrev <buffer> rrr return 
autocmd FileType python		:iabbrev <buffer> return AH_AH_AH\!

" i'm getting bored of :q!
cnoreabbrev Q q!
