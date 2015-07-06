if exists("b:current_syntax")
    finish
endif

syntax match rciconfComment "#.*$"
syntax region rciconfString start=/\v"/ skip=/\v\\./ end=/\v"/ oneline

syntax match rciconfFunction /group / nextgroup=rciconfFunction
syntax keyword rciconfFunction element value state setting
syntax keyword rciconfFunction globalerror error
syntax keyword rciconfKeyword type min max access units default
syntax keyword rciconfType string multiline_string password int32 uint32
syntax keyword rciconfType hex32 0x_hex32 float enum on_off boolean ipv4
syntax keyword rciconfType fqdnv4 fdqnv6 mac_addr datetime list multi xbee_ext_addr
syntax keyword rciconfType read_only read_write write_only
syntax match rciconfName / [a-zA-Z][a-zA-Z0-9_]\+/ nextgroup=rciconfString contained contains=@NoSpell
syntax match rciconfNumber "\<0\>"
syntax match rciconfNumber "\<[1-9][0-9]*\>"
highlight link rciconfNumber Number

syntax match rciconfFunction /(group|element|value)/ nextgroup=rciconfName

highlight link rciconfComment Comment
highlight link rciconfKeyword Keyword
highlight link rciconfName Type
highlight link rciconfType Type
highlight link rciconfFunction Function
highlight link rciconfString String

let b:current_syntax = "rciconf"
