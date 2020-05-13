set background=dark
highlight clear
if exists("syntax_on")
    syntax reset
endif

let colors_name = "cyber"

hi Normal ctermfg=Grey ctermbg=NONE

" Syntax highlighting (other color-groups using default, see :help group-name):
hi Comment     cterm=NONE ctermfg=DarkGrey
hi Constant    cterm=NONE ctermfg=DarkBlue
hi Identifier  cterm=NONE ctermfg=Blue
hi Function    cterm=NONE ctermfg=Green
hi Conditional cterm=NONE ctermfg=DarkGrey
hi Statement   cterm=bold ctermfg=DarkBlue
hi Operator    cterm=NONE ctermfg=DarkGreen

hi PreProc     cterm=NONE ctermfg=DarkCyan
hi Type	       cterm=NONE ctermfg=DarkGreen
hi Special     cterm=NONE ctermfg=DarkGreen
" hi Delimiter   cterm=NONE ctermfg=Yellow
hi LineNr      cterm=NONE ctermfg=LightGreen
hi Error       cterm=NONE ctermfg=White ctermbg=DarkRed
hi YcmErrorSection ctermbg=DarkRed
hi YcmWarningSection ctermbg=DarkYellow

hi Visual         ctermfg=Magenta ctermbg=Black
hi Search         cterm=bold ctermfg=Yellow ctermbg=Black
hi SpellBad       ctermfg=Black ctermbg=Red
hi SpellCap       ctermfg=Black ctermbg=DarkGrey
hi SpellRare      ctermfg=Black ctermbg=DarkBlue
hi SpellLocal     ctermfg=Black ctermbg=DarkGreen
hi MatchParen     ctermfg=White ctermbg=DarkGrey
