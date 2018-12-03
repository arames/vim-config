set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "quiet"

if !(has("gui_running") || &t_Co == 256)
	echom "The quiet colour scheme is designed for 256 colours or more."
	echom "In a recent vim, use `set t_Co=256`."
endif

hi Normal       ctermfg=252 ctermbg=233
hi LineNr       ctermfg=241
hi VertSplit    ctermfg=233 ctermbg=241
hi StatusLine   ctermfg=248 ctermbg=233
hi StatusLineNC ctermfg=235 ctermbg=252

hi Visual    ctermbg=237

" Used by vim-gitgutter. Clear to use the same as LineNr.
hi clear SignColumn

if version >= 700
  " Auto-completion
  hi Pmenu       ctermfg=252 ctermbg=22
  hi PmenuSel    ctermfg=0   ctermbg=34
  hi TabLine     ctermfg=252 ctermbg=233
  hi TabLineFill ctermfg=233 ctermbg=233
  hi TabLineSel  ctermfg=233 ctermbg=252
  hi MatchParen             ctermbg=6
endif

hi Search        ctermfg=204 ctermbg=NONE cterm=underline

hi PreProc       ctermfg=26
hi cppStructure  ctermfg=110
hi cStructure    ctermfg=110

" Control flow
hi Statement    ctermfg=179 ctermbg=NONE
hi cRepeat      ctermfg=179 ctermbg=NONE
hi cConditional ctermfg=179 ctermbg=NONE

hi StorageClass ctermfg=115 ctermbg=NONE

hi! link Identifier Normal
hi! link Type       Normal
hi! link Constant   Normal
hi! link Number     Normal

hi Comment   ctermfg=245 ctermbg=NONE
hi Todo      ctermfg=233 ctermbg=172

" Spelling
hi SpellBad  ctermfg=233 ctermbg=124
hi SpellCap  ctermfg=233 ctermbg=26

" Diff
hi DiffAdd    ctermfg=34  ctermbg=233
hi DiffDelete ctermfg=160 ctermbg=233
hi DiffText   ctermfg=Yellow ctermbg=233
hi! link DiffAdded DiffAdd
hi! link DiffRemoved DiffDelete

" YouCompleteMe
hi YcmErrorSign ctermfg=233 ctermbg=124
hi YcmErrorSection ctermfg=233 ctermbg=124
hi YcmWarningSign ctermfg=233 ctermbg=3
hi YcmWarningSection ctermfg=233 ctermbg=3

" LLVM
hi tgKeyword ctermfg=179
hi tgType ctermfg=110

" C++
hi! link cppStatement Normal
" TODO
hi! cppAccess ctermfg=3 ctermbg=233

" Markdown
hi markdownH1    ctermfg=161
hi markdownH2    ctermfg=162
hi markdownH3    ctermfg=163
hi markdownCode  ctermfg=110
hi! link markdownCodeBlock markdownCode

" Custom for vimrc
hi Green ctermfg=47
