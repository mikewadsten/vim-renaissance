" vim-renaissance .vimrc
" almost totally inspired by Learn Vimscript the Hard Way exercises,
" with various content lifted from spf13-vim

" Core toggles that I may want to hit later {
    " Value used for g:solarized_termtrans, to either let the terminal
    " background color shine through (1) or use a nice dark gray (0)
    let s:use_terminal_background = 1
" }

" Platform checking functions {
silent function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction

" Make Vim less like Vi
set nocompatible

" Source my bundles file.
if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
endif

set background=dark         " This is generally the case
" set background=light       " Let there be light! (optional)
filetype plugin indent on   " Auto-detect file types
syntax on                   " Syntax highlighting
set mouse=a                 " Enable mouse usage
set mousehide               " Hide cursor while typing
scriptencoding utf-8

if has('clipboard') && LINUX()
    set clipboard=unnamedplus    " Use + register for copy-paste
endif

" Switch to current file directory automatically
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

set shortmess+=filmnrxoOtTI " Abbreviate messages, and hide the intro
" Better Unix/Windows compatibility
set viewoptions=folds,options,cursor,unix,slash
set virtualedit=onemore     " Allow cursor to go past last character

set history=1000            " Dat history
if has('persistent_undo')
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

set spell                   " go go gadget spellcheck
set hidden                  " Allow buffer switching sans save

" Restore cursor to file position in previous editing session
function! RestoreCursor()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction
augroup resCur
    autocmd!
    autocmd BufWinEnter * call RestoreCursor()
augroup END

" core indentation settings
set tabstop=4
set expandtab
set shiftwidth=4
set shiftround

" Vundle no le gusta algunas shells
if &shell =~# 'fish$'
    set shell=/bin/bash
endif


" UI {
    if &term == 'xterm' || &term == 'screen'
        set t_Co=256 " Enable 256 colors. If I start using tmux, may need to revisit this.
    endif
    if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
        let g:solarized_termcolors=256
        let g:solarized_termtrans = s:use_terminal_background
        let g:solarized_contrast="high"
        "let g:solarized_visibility="normal"
        "let g:solarized_bold=1
        colorscheme solarized   " Solarized FTW
    endif

    set noshowmode    " Display the current mode

    set cursorline  " Solarized does this reasonably well, so why not

    highlight CursorLineNr ctermfg=153  " Pretty color for current line no

    set ruler       " Show the ruler

    if has('statusline')
        set laststatus=2
    endif

    set backspace=indent,eol,start      " Backspace for dummies
    set number                          " Show line numbers
    set showmatch                       " Highlight matching parens/brackets
    set incsearch                       " Find results as you type
    set hlsearch                        " Highlight search terms"
    set ignorecase                      " Case-insensitive search
    set smartcase                       " Case-sensitive if uppercase present
    "set wildmenu                        " Show list instead of completing
    set wildmode=list:longest,full      " Tab-complete with matches listed, etc.
    set whichwrap=b,s,h,l,<,>,[,]       " Backspace and cursor keys wrap as well
    set scrolljump=5                    " Lines to scroll when cursor goes out
    set scrolloff=3                     " Min. lines to keep around cursor

    set list
    set listchars=tab:,\ ,trail:\ ,extends:#,nbsp:\

    " Speed things up.
    set timeoutlen=500 ttimeoutlen=50
" }

" Formatting {
    set nowrap              " Don't wrap long lines
    set autoindent          " Indent to the same level as previous line
    set shiftwidth=4        " Indent to 4 spaces
    set expandtab           " Tabs are spaces, not tabs. (Fish are friends...)
    set tabstop=4           " Indenting stops every four columns
    set softtabstop=4       " Backspace deletes indents
    set nojoinspaces        " Prevent inserting 2 spaces after punctuation on J
    set pastetoggle=<F9>    " Toggle paste mode

    set textwidth=79
    set colorcolumn=80

    if has('dialog_con')
        " Function to trim trailing whitespace, if it exists, and confirmed.
        function! StripTrailingWS(...)
            " Save last search, and cursor position
            let _s=@/
            let l = line(".")
            let c = col(".")

            " Look for trailing whitespace first.
            if search('\s\+$')
                let l:stripit = 0

                if len(a:000)
                    " Bypass confirmation with first arg being truthy.
                    let l:stripit = a:0
                else
                    let l:msg = "Trailing whitespace detected. Strip it?"
                    let l:stripit = confirm(l:msg, "&Yes\n&No", 2)
                endif

                if l:stripit == 1  " Yes. Do that.
                    " Strip that whitespace
                    %s/\s\+$//e
                    echom "Trailing whitespace trimmed."

                    " Skip 'Press ENTER ...' prompt
                    silent redraw
                endif

                " Restore search, and cursor position.
                " (If search above failed, the cursor didn't move.)
                let @/=_s
                call cursor(l, c)
            endif
        endfunction

        autocmd FileType
                    \ c,cpp,java,php,javascript,python,xml,yml
                    \ autocmd BufWritePre <buffer> call StripTrailingWS()
        nnoremap <silent> <leader>W :call StripTrailingWS()<CR>
    endif
" }

" Key mappings {
    let mapleader = ','
    let maplocalleader = "\\"

    " Move around in insert mode by holding down Ctrl.
    " (I'd prefer Alt, but that doesn't work well...)
    " This needs to be ^H and not <C-h> because <C-h> is backspace
    inoremap  <C-o>h
    inoremap <C-j> <C-o>j
    inoremap <C-k> <C-o>k
    inoremap <C-l> <C-o>l

    " Navigate through wrapped lines by going to the next row, not line.
    noremap j gj
    noremap k gk

    nnoremap K i<CR><Esc>

    " Stupid shift key fixes
    if has("user_commands")
        command! -bang -nargs=* -complete=file E e<bang> <args>
        command! -bang -nargs=* -complete=file W w<bang> <args>
        command! -bang -nargs=* -complete=file Wq wq<bang> <args>
        command! -bang -nargs=* -complete=file WQ wq<bang> <args>
        command! -bang Wa wa<bang>
        command! -bang WA wa<bang>
        command! -bang Q q<bang>
        command! -bang QA qa<bang>
        command! -bang Qa qa<bang>
    endif

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Toggle search highlighting.
    nmap <silent> <leader>/ :set invhlsearch<CR>

    " Now this will be useful: Find merge conflict markers.
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Indent in visual mode.
    vnoremap < <gv
    vnoremap > >gv

    " Allow repeat operator to work on visual selection.
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo... Really WRITE the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers for edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%

    " Display all lines with keyword under cursor, and ask which one
    " to jump to.
    nmap <leader>ff [I:let nr = input("Which one? (Ctrl-C to abort):")
                \<Bar>exe "normal " . nr . "[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " easy line movement
    " up... (+ requires shift but = doesn't work)
    nnoremap + ddkP
    " and down
    nnoremap - ddp

    " ctrl-u to uppercase the current word when in normal mode
    " mark (k), upper case the word, go back to (k)
    nnoremap <c-u> mkviwU<esc>`k

    " easy vimrc editing
    nnoremap <leader>EV :split $MYVIMRC<CR>
    nnoremap <leader>SV :source $MYVIMRC<CR>
                \ :echo "Reloaded configuration from" expand("$MYVIMRC")<CR>

    " strong h and l movement
    nnoremap H 0
    nnoremap L $

    " because Escape is way over there
    inoremap jk <esc>
    " let's learn this mapping the hard way
    "inoremap <esc> <nop>
    " while we're at it, let's keep the arrows disabled
    noremap <Up> <nop>
    noremap <Down> <nop>
    noremap <Left> <nop>
    noremap <Right> <nop>

    " delete to black hole register (can't paste it back in)
    nnoremap <leader>d "_dd
    vnoremap <leader>d "_dd
    " screw you, shift key
    nnoremap ; :
" }

" Plugins {
    " Omnicompletion (not a plugin, really) {
        if has("autocmd") && exists("+omnifunc")
            autocmd Filetype *
                        \if &omnifunc == "" |
                        \setlocal omnifunc=syntaxcomplete#Complete |
                        \endif
        endif

        hi Pmenu ctermfg=black ctermbg=lightgray
        hi PmenuSbar ctermfg=darkcyan ctermbg=lightgray
        hi PmenuThumb ctermfg=lightgray ctermbg=darkgray

        "inoremap <expr> <Esc>       pumvisible() ? "\<C-e>" : "\<Esc>"
        "inoremap <expr> <CR>        pumvisible() ? "\<C-y>" : "\<CR>"
        "inoremap <expr> <Down>      pumvisible() ? "\<C-n>" : "\<Down>"
        "inoremap <expr> <Up>        pumvisible() ? "\<C-p>" : "\<Up>"
        "inoremap <expr> <C-d>       pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
        "inoremap <expr> <C-u>       pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

        " Automatically open and close the popup menu / preview window
        au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
        set completeopt=menu,preview,longest
    " }

    " Autoclose {
        let g:AutoClosePairs_add = "<>"
    " }

    " JSON {
        nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
    " }

    " ctrlp {
        let g:ctrlp_switch_buffer = 'e'
        let g:ctrlp_working_path_mode = 'ra'
        let g:ctrlp_custom_ignore = {
        \ 'dir':  '\.git$\|\.hg$\|\.svn$',
        \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

        if executable('ack')
            let s:ctrlp_fallback = 'ack %s --nocolor -f'
        elseif executable('ack-grep')
            let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
        else
            let s:ctrlp_fallback = 'find %s -type f'
        endif
        let g:ctrlp_user_command = {
            \ 'types': {
                \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
            \ 'fallback': s:ctrlp_fallback
        \ }
    " }

    " neocomplcache {
        let g:acp_enableAtStartup = 0
        let g:neocomplcache_enable_at_startup = 1
        let g:neocomplcache_enable_camel_case_completion = 1
        let g:neocomplcache_enable_smart_case = 1
        let g:neocomplcache_enable_underbar_completion = 1
        let g:neocomplcache_enable_auto_delimiter = 1
        let g:neocomplcache_max_list = 15
        let g:neocomplcache_force_overwrite_completefunc = 1

        " Define dictionary.
        let g:neocomplcache_dictionary_filetype_lists = {
                    \ 'default' : '',
                    \ 'vimshell' : $HOME.'/.vimshell_hist',
                    \ 'scheme' : $HOME.'/.gosh_completions'
                    \ }

        " Define keyword.
        if !exists('g:neocomplcache_keyword_patterns')
            let g:neocomplcache_keyword_patterns = {}
        endif
        let g:neocomplcache_keyword_patterns._ = '\h\w*'

        " Plugin key-mappings {
            " These two lines conflict with the default digraph mapping of <C-K>
            imap <C-k> <Plug>(neosnippet_expand_or_jump)
            smap <C-k> <Plug>(neosnippet_expand_or_jump)
            "if exists('g:spf13_noninvasive_completion')
                "iunmap <CR>
                "" <ESC> takes you out of insert mode
                "inoremap <expr> <Esc>   pumvisible() ? "\<C-y>\<Esc>" : "\<Esc>"
                "" <CR> accepts first, then sends the <CR>
                "inoremap <expr> <CR>    pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
                "" <Down> and <Up> cycle like <Tab> and <S-Tab>
                "inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Down>"
                "inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
                "" Jump up and down the list
                "inoremap <expr> <C-d>   pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
                "inoremap <expr> <C-u>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
            "else
                imap <silent><expr><C-k> neosnippet#expandable() ?
                            \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
                            \ "\<C-e>" : "\<Plug>(neosnippet_expand_or_jump)")
                smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

                inoremap <expr><C-g> neocomplcache#undo_completion()
                inoremap <expr><C-l> neocomplcache#complete_common_string()
                inoremap <expr><CR> neocomplcache#complete_common_string()

                " <CR>: close popup
                " <s-CR>: close popup and save indent.
                inoremap <expr><s-CR> pumvisible() ? neocomplcache#close_popup()"\<CR>" : "\<CR>"
                inoremap <expr><CR> pumvisible() ? neocomplcache#close_popup() : "\<CR>"

                " <C-h>, <BS>: close popup and delete backword char.
                inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
                inoremap <expr><C-y> neocomplcache#close_popup()
            "endif
            " <TAB>: completion.
            inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
            inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

            " Press Enter on snippet option to plug it in.
            "imap <silent><expr><CR> pumvisible() ? "\<C-k>" : "\<CR>"
        " }

        " Enable omni completion.
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
        autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

        " Enable heavy omni completion.
        if !exists('g:neocomplcache_omni_patterns')
            let g:neocomplcache_omni_patterns = {}
        endif
        let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
        let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
        let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
        let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
        let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
    " }

    " Snippets {
        " Use honza's snippets.
        let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

        " Enable neosnippet snipmate compatibility mode
        let g:neosnippet#enable_snipmate_compatibility = 1

        " For snippet_complete marker.
        if !exists("g:spf13_no_conceal")
            if has('conceal')
                set conceallevel=2 concealcursor=i
            endif
        endif

        " Disable the neosnippet preview candidate window
        " When enabled, there can be too much visual noise
        " especially when splits are used.
        set completeopt-=preview
    " }

    " UndoTree {
        nnoremap <Leader>u :UndotreeToggle<CR>
        " Focus current undotree window on toggle.
        let g:undotree_SetFocusWhenToggle=1
    " }

    " ConqueTerm {
        if exists('g:ConqueTerm_Version') " Check for ConqueTerm first.
            let g:ConqueTerm_FastMode = 1
            let g:ConqueTerm_CloseOnEnd = 1
            let g:ConqueTerm_StartMessages = 0

            nnoremap <Leader>cq :ConqueTermVSplit<Space>
        endif
    " }

    " vim-airline {
        set noshowmode  " Airline shows mode.
        if exists('g:loaded_airline')
            if !exists('g:airline_powerline_fonts')
                "let g:airline_left_sep='›'
                "let g:airline_right_sep='‹'
                let g:airline_left_sep = ''
                let g:airline_right_sep = ''
                let g:airline_symbols = {}
                let g:airline_left_sep = '⮀'
                let g:airline_left_alt_sep = '⮁'
                let g:airline_right_sep = '⮂'
                let g:airline_right_alt_sep = '⮃'
                let g:airline_symbols.branch = '⭠'
                let g:airline_symbols.readonly = '⭤'
                let g:airline_symbols.linenr = '⭡'
            endif

            let g:airline#extensions#hunks#non_zero_only = 1
            let g:airline#extensions#default#section_truncate_width = {}
            let g:airline#extensions#default#layout = [
                        \ [ 'a', 'b' ],
                        \ [ 'x', 'y', 'z', 'warning' ]
                        \ ]


            let g:airline_mode_map = {
                \ '__' : '-',
                \ 'n'  : 'Nrm',
                \ 'i'  : 'Ins',
                \ 'R'  : 'Rep',
                \ 'c'  : 'Cmd',
                \ 'v'  : 'Vis',
                \ 'V'  : 'VLine',
                \ '' : 'VBlock',
                \ 's'  : 'Sel',
                \ 'S'  : 'SLine',
                \ '' : 'SBlock'
                \ }
        endif
    " }

    " tmuxline.vim {
        " Disable automatic rejiggering of tmux statusbar color theme.
        let g:airline#extensions#tmuxline#enabled = 0
        " Disable powerline symbols as section separators
        let g:tmuxline_powerline_separators = 0
    " }

    " TagBar {
        nnoremap <silent> <leader>tt :TagbarToggle<CR>
    " }

    " Lightline.vim {
        " Bufferline configuration
        let g:bufferline_echo = 0  " Hide bufferline at the moment

        " A really decent lightline configuration.
        " https://github.com/itchyny/lightline.vim/issues/36
        let g:lightline = {
            \ 'colorscheme': 'jellybeans',
            \ 'active': {
            \   'left': [
            \       ['mode', 'paste'],
            \       ['fugitive', 'readonly'],
            \       ['bufferline'],
            \   ],
            \   'right': [
            \       ['lineinfo'],
            \       ['percent'],
            \       ['fileformat', 'fileencoding', 'filetype'],
            \       ['tagbar']
            \   ]
            \ },
            \ 'component': {
            \   'paste'  : '%{&paste ? "PASTE" : ""}',
            \   'tagbar' : '%{tagbar#currenttag("[%s]", "")}'
            \ },
            \ 'component_function': {
            \   'mode'          : 'MyMode',
            \   'fugitive'      : 'MyFugitive',
            \   'readonly'      : 'MyReadonly',
            \   'ctrlpmark'     : 'CtrlPMark',
            \   'bufferline'    : 'MyBufferline',
            \   'fileformat'    : 'MyFileformat',
            \   'fileenconding' : 'MyFileencoding',
            \   'filetype'      : 'MyFiletype'
            \ },
            \ 'subseparator': {
            \   'left': '|', 'right': '|'
            \ }
            \ }

        function! MyMode()
            let fname = expand('%:t')
            return fname == '__Tagbar__' ? 'Tagbar' :
                    \ fname == 'ControlP' ? 'CtrlP' :
                    \ winwidth('.') > 60 ? lightline#mode() : ''
        endfunction

        function! MyFugitive()
            try
                if expand('%:t') !~? 'Tagbar' && exists('*fugitive#head')
                    let mark = '∓ '
                    let _ = fugitive#head()
                    return strlen(_) ? mark._ : ''
                endif
            catch
            endtry
            return ''
        endfunction

        function! MyReadonly()
            return &ft !~? 'help' && &readonly ? '⭤' : ''
        endfunction

        function! CtrlPMark()
            if expand('%:t') =~ 'ControlP'
                call lightline#link('iR'[g:lightline.ctrlp_regex])
                return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
                    \ , g:lightline.ctrlp_next], 0)
            else
                return ''
            endif
        endfunction

        function! MyBufferline()
            " Tagbar and CtrlP will already show the mode, no need to also show
            " a buffer name.
            let l:curmode = MyMode()
            if l:curmode =~ 'Tagbar' || l:curmode =~ 'CtrlP'
                return ''
            endif
            unlet l:curmode

            call bufferline#refresh_status()
            let b = g:bufferline_status_info.before
            let c = g:bufferline_status_info.current
            let a = g:bufferline_status_info.after
            let alen = strlen(a)
            let blen = strlen(b)
            let clen = strlen(c)
            let w = winwidth(0) * 4 / 11
            if w < alen+blen+clen
                let whalf = (w - strlen(c)) / 2
                let aa = alen > whalf && blen > whalf ? a[:whalf] : alen + blen < w - clen || alen < whalf ? a : a[:(w - clen - blen)]
                let bb = alen > whalf && blen > whalf ? b[-(whalf):] : alen + blen < w - clen || blen < whalf ? b : b[-(w - clen - alen):]
                return (strlen(bb) < strlen(b) ? '...' : '') . bb . c . aa . (strlen(aa) < strlen(a) ? '...' : '')
            else
                return b . c . a
            endif
        endfunction

        function! MyFileformat()
            return winwidth('.') > 90 ? &fileformat : ''
        endfunction

        function! MyFileencoding()
            return winwidth('.') > 80 ? (strlen(&fenc) ? &fenc : &enc) : ''
        endfunction

        function! MyFiletype()
            return winwidth('.') > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
        endfunction

        let g:ctrlp_status_func = {
            \ 'main': 'CtrlPStatusFunc_1',
            \ 'prog': 'CtrlPStatusFunc_2',
            \ }

        function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
            let g:lightline.ctrlp_regex = a:regex
            let g:lightline.ctrlp_prev = a:prev
            let g:lightline.ctrlp_item = a:item
            let g:lightline.ctrlp_next = a:next
            return lightline#statusline(0)
        endfunction

        function! CtrlPStatusFunc_2(str)
            return lightline#statusline(0)
        endfunction

        let g:tagbar_status_func = 'TagbarStatusFunc'

        function! TagbarStatusFunc(current, sort, fname, ...) abort
            let g:lightline.fname = a:fname
            return lightline#statusline(0)
        endfunction
    " }

    " CtrlP {
        let g:ctrlp_cmd = "CtrlPMixed"
    " }
" }

" auto correct ftw
iabbrev adn and
iabbrev th the
" doesn't tpope have a plugin for this? abolish?

" Don't auto-close double-quotes since those are comments.
autocmd FileType vim            let g:AutoClosePairs_del .= '"'

" Initialize directories {
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        " To specify a different directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories, add the following to
        " your .vimrc.before.local file:
        "   let g:spf13_consolidated_directory = <full path to desired directory>
        "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
        if exists('g:spf13_consolidated_directory')
            let common_dir = g:spf13_consolidated_directory . prefix
        else
            let common_dir = parent . '/.' . prefix
        endif

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()
" }
