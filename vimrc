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

" Set vim-renaissance onto the runtime path.
if isdirectory(expand("~/personal/dotfiles/vim-renaissance/compiler"))
    execute "set rtp+=" . expand("~/personal/dotfiles/vim-renaissance")
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

if has('gui')
    if LINUX()
        set guifont=Meslo\ LG\ M\ for\ Powerline\ 10
    else
        " Set font in MacVim
        set guifont=Meslo\ LG\ M\ Regular\ for\ Powerline:h14
    endif
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
    if &filetype == "netrw"
        return 1
    endif
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction
augroup resCur
    autocmd!
    autocmd BufWinEnter * call RestoreCursor()
augroup END

" Use = to close vinegar browser.
augroup mikeVinegar
    autocmd!
    autocmd FileType netrw nmap <buffer> <silent> = :e #<CR>
    autocmd FileType netrw nmap <buffer> <silent> <leader>p <C-w>z
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
    if filereadable(expand("~/.vim/plugged/vim-colors-solarized/colors/solarized.vim"))
        let g:solarized_termcolors=256
        let g:solarized_termtrans = s:use_terminal_background
        let g:solarized_contrast="high"
        "let g:solarized_visibility="normal"
        "let g:solarized_bold=1
        colorscheme solarized   " Solarized FTW
    endif

    set noshowmode    " Don't display the current mode; that's what lightline is for

    set cursorline  " Solarized does this reasonably well, so why not

    highlight CursorLineNr ctermfg=153  " Pretty color for current line no

    set ruler       " Show the ruler

    if has('statusline')
        set laststatus=2
    endif

    set backspace=indent,eol,start      " Backspace for dummies
    set relativenumber                  " Show line numbers relative to position
    set number                          " Show line numbers
    set noshowmatch                     " This just slows down typing, ew ew ew
    set incsearch                       " Find results as you type
    set hlsearch                        " Highlight search terms
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

    " Muchas gracias, @janko-m
    " https://github.com/tpope/vim-sensible/pull/85
    if v:version > 703 || v:version == 703 && has("patch541")
        " Delete comment character when joining commented lines
        set formatoptions+=j
    endif

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
    " Experimentation time
    "let mapleader = "\<Space>"
    let maplocalleader = "\\"

    " Navigate through wrapped lines by going to the next row, not line.
    noremap j gj
    noremap k gk

    " Opposite of 'J'; splits line at cursor position
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
    " I've become addicted to hitting q for everything...
    " and who starts recording a macro when IN visual mode?
    vnoremap q <Esc>

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

    " strong h and l movement
    nnoremap H 0
    nnoremap L $

    " because Escape is way over there
    inoremap jk <esc>
    " while we're at it, let's keep the arrows disabled
    noremap <Up> <nop>
    noremap <Down> <nop>
    " but not left and right, which move twixt buffers

    " delete to black hole register (can't paste it back in)
    nnoremap <leader>d "_dd
    vnoremap <leader>d "_d
    " screw you, shift key
    nnoremap ; :

    " I don't want to press the shift key to force exit anymore.
    cabbrev q1 q!<CR>

    " I have literally never used Ex mode. Make Q more useful
    nnoremap Q @@
" }

" ctags, cscope, gtags keymappings {
augroup mikeCscope
    function! s:AddCscopeConn()
        if exists('g:mike_stop_autocscope') && g:mike_stop_autocscope == 1
            return
        endif
        setl cscopeprg=cscope
        let cscopefile=b:git_dir . '/cscope'
        let rootdir=simplify(fnamemodify(b:git_dir, ':p:h:h'))

        if filereadable(cscopefile)
            try
                exe "cs kill -1"
                exe "cs add " . cscopefile . " " . rootdir
            catch
            endtry
        endif
    endfunction

    function! s:AddGtagsCscopeConn()
        if exists('g:mike_stop_autocscope') && g:mike_stop_autocscope == 1
            return
        endif
        setl cscopeprg=gtags-cscope

        let rootdir=simplify(fnamemodify(b:git_dir, ':p:h:h'))
        let tagsfile=rootdir . "/GTAGS"

        if filereadable(tagsfile)
            try
                exe "cs kill -1"
                " NOTE: These are what actually get the integration with
                " gtags-cscope working, it seems... Yay GNU!
                let $GTAGSROOT = rootdir
                let $GTAGSDBPATH = rootdir
                exe "cs add " . tagsfile . " " . rootdir . " -ia"
            catch
            endtry
        endif
    endfunction

    command! MikeInitCscope call s:AddCscopeConn()

    if executable("gtags-cscope")
        " GTAGS > cscope. Probably.
        autocmd User Fugitive call s:AddGtagsCscopeConn()

        command MikeInitCscopeGtags call s:AddGtagsCscopeConn()
    elseif executable("cscope")
        " cscope is alright
        autocmd User Fugitive call s:AddCscopeConn()
    endif
augroup END

if executable("cscope") || executable("gtags-cscope")
    " Use both cscope and ctags for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags - if 1
    set csto=0

    " show messages when cscope db is added
    set nocscopeverbose

    function! s:mike_handleCscope(key)
        let l:commonarg = expand('<cword>')
        let l:cfile = expand('<cfile>')
        let l:csfindargs = {
                    \'s': l:commonarg,
                    \'g': l:commonarg,
                    \'t': l:commonarg,
                    \'c': l:commonarg,
                    \'d': l:commonarg,
                    \'e': l:commonarg,
                    \'f': l:cfile,
                    \'i': l:cfile
                    \}

        let value = l:csfindargs[a:key]
        if value == ''
            echo "No cword or cfile, you bozo"
            return
        endif

        try
            execute "cs find " . a:key . " " . value
        catch /.*/
            echo "cscope: " . v:exception
        endtry
    endfunction

    function! PromptCscope()
        let l:shortcuts = ['s', 'g', 't', 'c', 'd', 'e', 'f', 'i']
        let l:prompt = "&symbol\n&gdefinition\n&text\n&calls\ncalle&d by this\n&egrep\ngo to &file\n&includes"
        let which = confirm("cscope search type?", l:prompt, 0)
        if which
            let short = l:shortcuts[which - 1]
            call <SID>mike_handleCscope(short)
        endif
    endfunction

    " Ctrl-Space (Ctrl-)?[?<Space>] brings up the prompt.
    nnoremap <silent> <C-@>? :call PromptCscope()<CR>
    nnoremap <silent> <C-@><Space> :call PromptCscope()<CR>
    nnoremap <silent> <C-@><C-?> :call PromptCscope()<CR>
    nnoremap <silent> <C-@><C-@> :call PromptCscope()<CR>
    " Mappings to do cscope operations. My muscle memory is improving.
    nnoremap <silent> <C-@>s :call <SID>mike_handleCscope('s')<CR>
    nnoremap <silent> <C-@>g :call <SID>mike_handleCscope('g')<CR>
    nnoremap <silent> <C-@>t :call <SID>mike_handleCscope('t')<CR>
    nnoremap <silent> <C-@>c :call <SID>mike_handleCscope('c')<CR>
    nnoremap <silent> <C-@>d :call <SID>mike_handleCscope('d')<CR>
    nnoremap <silent> <C-@>e :call <SID>mike_handleCscope('e')<CR>
    nnoremap <silent> <C-@>f :call <SID>mike_handleCscope('f')<CR>
    nnoremap <silent> <C-@>i :call <SID>mike_handleCscope('i')<CR>
endif

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
        au Filetype html,xml let g:AutoClosePairs_add = "<>"
    " }

    " JSON {
        nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
    " }

    " ctrlp {
        let g:ctrlp_switch_buffer = 'e'
        let g:ctrlp_working_path_mode = 'ra'
        let g:ctrlp_custom_ignore = {
        \ 'dir':  '\.git$\|\.hg$\|\.svn$\|\.vim$|'.$HOME.'/\(Library\|Music\)$',
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
        let g:neosnippet#snippets_directory='~/.vim/plugged/vim-snippets/snippets'

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
        " ,tt to toggle Tagbar window.
        nnoremap <silent> <leader>tt :TagbarToggle<CR>
        " ,to to open Tagbar, or jump to it if it's open.
        nnoremap <silent> <leader>to :TagbarOpen fj<CR>
        " ,tl to switch out of Tagbar window (actually, to switch windows
        " period...)
        nnoremap <silent> <leader>tl <c-w>w
        " ,w to switch windows. Fits in nicely with Tagbar use.
        nnoremap <silent> <leader>w <c-w>w
        " ,W to switch to previous window
        nnoremap <silent> <leader>W <c-w>W
    " }

    " Lightline.vim {
        " TOTAL HACK TODO XXX FIXME
    if get(g:, 'loaded_lightline')

        " Bufferline configuration
        let g:bufferline_echo = 0  " Hide bufferline at the moment

        " A really decent lightline configuration.
        " https://github.com/itchyny/lightline.vim/issues/36
        let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ 'active': {
            \   'left': [
            \       ['mode', 'paste'],
            \       ['fugitive', 'readonly'],
            \       ['bufferline'],
            \   ],
            \   'right': [
            \       ['lineinfo'],
            \       ['percent'],
            \       ['fileformat', 'fileencoding', 'filetype']
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
            \   'filetype'      : 'MyFiletype',
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

    " END TOTAL HACK TODO XXX FIXME
    endif
    " }

    " CtrlP {
        let g:ctrlp_cmd = "CtrlPMixed"
    " }

    " indent_guides {
        let g:indent_guides_start_level = 2
        let g:indent_guides_guide_size = 1
        let g:indent_guides_enable_on_vim_startup = 1

        " Nice colors.
        let g:indent_guides_auto_colors = 0
        autocmd VimEnter,ColorScheme * :hi IndentGuidesEven ctermbg=239
        autocmd VimEnter,ColorScheme * :hi IndentGuidesOdd ctermbg=236
    " }

    " jedi-vim {
        "let g:jedi#use_tabs_not_buffers = 0
        "let g:jedi#use_splits_not_buffers = "left"
        let g:jedi#documentation_command = ""
        let g:jedi#goto_definitions_command = "<leader>jd"
        let g:jedi#goto_assignments_command = "<leader>ja"

        let g:jedi#popup_on_dot = 0
    " }

    " vim-json {
        let g:vim_json_syntax_conceal = 0
    " }

    " vim-gitwildignore {
        let g:gitwildignore_use_ls_files = 1

        let g:gitwildignore_patterns = {'/': ['*.pyc', '*.sw[op]', 'venv']}
    " }

    " numbertoggle {
        if v:version < 704
            let g:NumberToggleTrigger = '<F2>'
        endif

    " emmet.io {
        nnoremap <leader>z <End> :call emmet#expandAbbr(3, "")<CR>
    " }

    " switch.vim {
        nnoremap <silent> <BS> :Switch<CR>

        " CppUTest test macros
        let s:switch_cpputest = {
                    \ '\<TEST\>': 'IGNORE_TEST',
                    \ '\<IGNORE_TEST\>': 'TEST' }
        autocmd FileType cpp let b:switch_custom_definitions =
                    \ [
                    \   s:switch_cpputest
                    \ ]
    " }

    " ag.vim {
        nnoremap <Leader>a :Ag<Space>
        nmap <Leader>g <Leader>a
    " }
" }

" auto correct ftw
iabbrev adn and
iabbrev th the
" doesn't tpope have a plugin for this? abolish?

" Don't auto-close double-quotes since those are comments.
autocmd FileType vim            let g:AutoClosePairs_del .= '"'

" Turns out quickfixes should be available via <CR>...
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

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

" Neovim {
if has('nvim')
    function! s:HandleTermOpen()
        " Disable spell-checking, line highlighting, line numbers.
        setlocal nospell nocursorline colorcolumn=

        " Map the Escape key to return to normal mode from "insert."
        tnoremap <buffer> <Esc> <C-\><C-n>
    endfunction

    autocmd TermOpen * call s:HandleTermOpen()
endif
" }

" Work-specific things {
    if filereadable(expand("~/.vimrc.digi"))
        source ~/.vimrc.digi
    endif
" }

" Recent experimentation
hi LineNR ctermbg=NONE ctermfg=237
hi VertSplit ctermbg=236 ctermfg=236

" The following content provided by:
" howivim airblade

hi clear StatusLine
hi clear StatusLineNC
hi StatusLine   term=bold cterm=bold ctermfg=White ctermbg=235
hi StatusLineNC term=bold cterm=bold ctermfg=White ctermbg=236
hi User1                      ctermfg=4          guifg=#40ffff            " Identifier
hi User2                      ctermfg=2 gui=bold guifg=#ffff60            " Statement
hi User3 term=bold cterm=bold ctermfg=1          guifg=White   guibg=Red  " Error
hi User4                      ctermfg=1          guifg=Orange             " Special
hi User5                      ctermfg=10         guifg=#80a0ff            " Comment
hi User6 term=bold cterm=bold ctermfg=1          guifg=Red                " WarningMsg
set laststatus=2
set stl=%6*%m%r%*%5*%{expand('%:p:h')}/%1*%t%=line\ %l\ (%p%%)

nnoremap <Tab> <C-W>w
nnoremap <S-Tab> <C-W>W

" Retain cursor position when visually yanking.
vnoremap <silent> y 'my"' . v:register . 'y`y'
vnoremap <silent> Y 'my"' . v:register . 'Y`y'
