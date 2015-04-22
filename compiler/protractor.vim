if exists("current_compiler")
    finish
endif
let current_compiler = "protractor"

if exists(":CompilerSet") != 2 " older Vim always used setlocal
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=protractor

CompilerSet errorformat =
            \%E\ \ %\\d%\\+)\ %m,
            \%Z%\\s%\\+at\ %.%#.<anonymous>\ (%f:%l:%c),
            \%C\ \ \ Message:,
            \%C\ \ \ \ %m.,
            \%C%>\ \ \ Stacktrace:,
            \%-G%.%#,
            \%-G%.%#

" Workaround for https://github.com/tpope/vim-dispatch/issues/75
if g:loaded_dispatch
    CompilerSet errorformat+=%-G%.%#
endif
