set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "quiet_ajr"

if !(has("gui_running") || &t_Co == 256)
	echom "The quiet_ajr colour scheme is designed for 256 colours or more."
	echom "In a recent terminal, use `set t_Co=256`."
endif

hi Normal    ctermfg=251 ctermbg=233
hi LineNr    ctermfg=241
hi Visual    ctermbg=237

if version >= 700
  " Auto-completion
  hi Pmenu    ctermfg=251 ctermbg=22
  hi PmenuSel ctermfg=0   ctermbg=34
endif

hi Search    ctermfg=204 ctermbg=NONE cterm=underline

hi Statement ctermfg=179 ctermbg=NONE
hi PreProc   ctermfg=12

hi! link Type     Normal
hi! link Constant Normal
hi! link Number   Normal

hi Comment   ctermfg=245 ctermbg=NONE
hi Todo      ctermfg=233 ctermbg=172

" Spelling
hi SpellBad  ctermfg=233 ctermbg=124
hi SpellCap  ctermfg=233 ctermbg=26
