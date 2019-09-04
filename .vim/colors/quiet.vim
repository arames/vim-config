set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "quiet"

" Reference groups

hi       Normal               guifg=#bbbbbb guibg=#111111 gui=none
hi       NormalUnderline      guifg=#bbbbbb guibg=#111111 gui=underline

hi       LowInterest          guifg=#777777               gui=none
hi       LowInterestBold      guifg=#777777               gui=bold
hi       Interest             guifg=#c08000               gui=none
hi       InterestBold         guifg=#c08000               gui=bold
hi       HighInterest         guifg=#cc2244 guibg=none    gui=none
hi       HighInterestBg       guifg=none    guibg=#cc2244 gui=none

hi       Focus                guifg=#11aa11               gui=none
hi       FocusBg                            guibg=#115511 gui=none

hi       Error                guifg=#111111 guibg=#bb0000 gui=bold
hi       Warning              guifg=#111111 guibg=#c08000 gui=bold


" Usual groups

hi! link Identifier           Normal
hi! link Comment              LowInterest
hi! link Todo                 LowInterestBold
hi! link Search               HighInterest
hi! link MatchParen           FocusBg
hi       Visual                             guibg=#183058 gui=none

hi! link NonText              LowInterest
hi! link LineNr               LowInterest
hi! link Cursor               HighInterestBg
hi! link CursorLineNr         Normal
hi! link VertSplit            LowInterest
" hi  CursorLine              guibg=#222222

hi! link TabLine              LowInterest
hi! link TabLineFill          LowInterest
hi! link TabLineSel           NormalUnderline
hi! link Title                TabLine
hi! link SignColumn           Normal 

hi  Pmenu                                   guibg=#113311
hi  PmenuSel                                guibg=#115511

hi! Constant                  guifg=#99bb99               gui=none
hi  PreProc                   guifg=#aa44bb               gui=none
hi  Type                      guifg=#5599cc               gui=none
hi! link Statement            Interest

" Diff
hi! link diffIndexLine        Normal
hi! link diffFile             Interest
hi! link diffNewFile          Interest
hi! link diffLine             Normal
hi! link diffSubname          Type

hi  DiffAdd              guifg=#00aa00 guibg=#111111 gui=none
hi  DiffDelete           guifg=#cc0000 guibg=#111111 gui=none
hi! link DiffText Normal
hi! link diffAdded   DiffAdd
hi! link diffChange  Interest
hi! link diffRemoved DiffDelete

" Plugin-specific groups

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
