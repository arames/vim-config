" .vimrc
" by A. Rames <alexandre.rames@gmail.com>
"
" The configuration is targeted at and has only been tested on terminal vim.

" Use Vim settings, rather then Vi settings.
" This must be first, because it changes other options as a side effect.
set nocompatible

set shell=/bin/bash

set encoding=utf-8

set history=10000               " Keep 10000 lines of command line history.
set mouse=a                     " Enable the use of the mouse.
set ignorecase                  " Ignore case in search by default.
set smartcase                   " Case insensitive if no uppercase in the search.
set wildignore=*.bak,*.o,*.e,*~ " Wildmenu: ignore these extensions.
set wildmenu                    " Command-line completion in an enhanced mode.
set wildmode=list:longest       " Complete longest common string and list alternatives.
set showcmd                     " Display incomplete commands.

let hostname = substitute(system('hostname'), '\n', '', '')
if hostname == "achille"
  let mapleader = "\"
endif

" Load/save and automatic backup ==========================================={{{1

set backup  " Backup edited files.
set backupdir=~/.vim/backup
set viewdir=~/.vim/view
" Create directories if they don't already exist.
if !isdirectory(&backupdir)
  exec "silent !mkdir -p " . &backupdir
endif
if !isdirectory(&viewdir)
  exec "silent !mkdir -p " . &viewdir
endif

" Automatically save and load views.
autocmd BufWinLeave,BufWrite *.* mkview
autocmd BufWinEnter *.* silent loadview

" Jump to last known cursor position when editing a file.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

set autoread     " Automatically reload files changed on the disk.
set autowrite    " Write a modified buffer on each :next , ...

" Autodetect filetype on first save.
autocmd BufWritePost * if &ft == "" | filetype detect | endif

" Automatcially delete trailing whitespace on save
command! NukeTrailingWhitespace :%s/\s\+$//e
"autocmd BufWritePre * :%s/\s\+$//e

" Plug-ins ================================================================={{{1

" Use Vundle to manage the plugins.
" https://github.com/gmarik/vundle

" Required by Vundle.
filetype off

set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

" Required by Vundle.
Bundle 'gmarik/vundle'

" List of plugins to manage.
" Quickly move around.
Bundle 'Lokaltog/vim-easymotion'
let g:EasyMotion_leader_key = ','
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
" Better support for the markdown syntax.
Bundle 'plasticboy/vim-markdown'
" Word highlighting.
Bundle 'vim-scripts/Mark--Karkat'
" Git integration.
Bundle 'tpope/vim-fugitive'
" Display lines git diff status when editing a file in a git repository.
Bundle 'airblade/vim-gitgutter'

"" Asynchronous commands
"Bundle 'tpope/vim-dispatch'
" Use tabs for indentation and spaces for alignment (when using tabs).
" TODO: Unluckily this breaks /**/ comments closing.
" Bundle 'vim-scripts/Smart-Tabs'
" TODO: This one doesn't work for me.
"Bundle 'vim-scripts/ingo-library'
"Bundle 'vim-scripts/IndentTab'
""Bundle 'Valloric/YouCompleteMe'
"Bundle 'vim-scripts/Align'
"" Need to work out how to get it working for more complex projects.
""Bundle 'scrooloose/syntastic'

" Easy jump from diff to file.
" Note that by default the plugin opens diffs in a new buffer, even if the
" associated file is already opened. If the file is already opened in a buffer,
" the following patch instead jumps to the buffer and to the right location.
" --- a/ftplugin/diff_gofile.vim
" +++ b/ftplugin/diff_gofile.vim
" @@ -92,7 +92,7 @@ function DiffGoFile(doSplit)
"
"         " restore position in diff window
"         call <SID>RestoreCursorPosition (l:pos)
" -       call <SID>FindOrCreateBuffer(l:file, a:doSplit, 0)
" +       call <SID>FindOrCreateBuffer(l:file, a:doSplit, 1)
"         call <SID>RestoreCursorPosition (l:result[1:])
"  endfunction
"  endif
Bundle 'vim-scripts/DiffGoFile'
autocmd FileType diff nnoremap <buffer> <C-]> :call DiffGoFile('n')<CR>
autocmd FileType diff nnoremap <buffer> <C-v><C-]> :call DiffGoFile('v')<CR>

" Personal wiki
Bundle 'vim-scripts/vimwiki'
" Use the markdown syntax
let g:vimwiki_list = [{'path': '~/repos/vimwiki/',
                     \ 'syntax': 'markdown', 'ext': '.md'}]

" Required by Vundle.
filetype plugin indent on


" Presentation ============================================================={{{1

set t_Co=256                    " 256 colors.
syntax on                       " Enable syntax highlighting.
" Custom color scheme, based on the jellybeans color scheme available at
"   http://www.vim.org/scripts/script.php?script_id=2555
colorscheme quiet
set ruler                       " Show the cursor position all the time.
set winminheight=0              " Minimum size of splits is 0.
set nowrap                      " Do not wrap lines.
set noerrorbells                " No bells.
"let &sbr = nr2char(8618).' '    " Show ↪ at the beginning of wrapped lines.

" Display relative line numbers in normal mode and absolute line numbers
" in insert mode.
set relativenumber                      " Display line numbers.
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

" Editing =================================================================={{{1

set backspace=indent,eol,start       " Backspacing over everything in insert mode.
set hlsearch                         " Highlight the last used search pattern.
set showmatch                        " Briefly display matching bracket.
set matchtime=5                      " Time (*0.1s) to show matching bracket.
set incsearch                        " Do incremental searching.
set tags=.tags

" Turn off last search highlighting
nmap <Space> :nohlsearch<CR>

" Move between splits.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Easy bracketing in visual mode.
" Take care of saving the unnamed register.
vnoremap <leader>(  :<C-u>let@z=@"<CR>gvs()<Esc>P<Right>%:<C-u>let@"=@z<CR>
vnoremap <leader>[  :<C-u>let@z=@"<CR>gvs[]<Esc>P<Right>%:<C-u>let@"=@z<CR>
vnoremap <leader>{  :<C-u>let@z=@"<CR>gvs{}<Esc>P<Right>%:<C-u>let@"=@z<CR>
xnoremap <leader>'  :<C-u>let@z=@"<CR>gvs''<Esc>P<Right>%:<C-u>let@"=@z<CR>
xnoremap <leader>"  :<C-u>let@z=@"<CR>gvs""<Esc>P<Right>%:<C-u>let@"=@z<CR>
xnoremap <leader>`  :<C-u>let@z=@"<CR>gvs``<Esc>P<Right>%:<C-u>let@"=@z<CR>

" Completion ==========================================={{{2
" Display a menu, insert the longest common prefix but don't select the first
" entry, and display some additional information if available.
set completeopt=menu,longest,preview

" Grep/tags ============================================{{{2

" Grep in current directory.
set grepprg=grep\ -RHIn\ --exclude=\".tags\"\ --exclude-dir=\".svn\"\ --exclude-dir=\".git\"
" Grep for the word under the cursor or the selected text.
nnoremap <F8> :Grep "<C-r><C-w>" .<CR>
nnoremap <leader>grep :Grep "<C-r><C-w>" .<CR>
vnoremap <leader>grep "zy:<C-u>Grep "<C-r>z" .<CR>
" The extended versions cause vim to wait for a further key.
" If the wait is too long press space!
nnoremap <leader>grep<Space> :Grep "<C-r><C-w>" .<CR>
vnoremap <leader>grep<Space> "zy:<C-u>Grep "<C-r>z" .<CR>
" Grep for text with word boundaries.
nnoremap <leader>grepw :Grep "\\<<C-r><C-w>\\>" .<CR>
vnoremap <leader>grepw "zy:<C-u>Grep "\\<<C-r>z\\>" .<CR>

" Background grep
let g:BgGrep_res = '/tmp/vim.grep.res'
let s:BgGrep_command = 'silent !' . &grepprg
command! -nargs=* -complete=dir Grep call Async(s:BgGrep_command, 'BgGrepStart()', 'BgGrepDone()', g:BgGrep_res, <f-args>)
function! BgGrepStart()
  echohl Error | echo 'Running background grep...' | echohl None
endfunction
function! BgGrepDone()
  exec('cgetfile' . g:BgGrep_res)
  echohl Error | echo "Background grep done." | echohl None
endfunction

" Update tags file.
" --c-kind=+p considers function definitions.
" --fields=+S registers signature of functions.
let s:TagsUpdate_command = 'silent !ctags -o .tags -R --c-kinds=+p --c++-kinds=+p --fields=+iaS --extra=+q'
function! TagsUpdateStart()
  echohl Error | echo "Building tags..." | echohl None
endfunction
function! TagsUpdateDone()
  echohl Error | echo "Done building tags." | echohl None
endfunction
command! -nargs=* -complete=dir TagsUpdate call Async(s:TagsUpdate_command, 'TagsUpdateStart()', 'TagsUpdateDone()', '/dev/null', <f-args>)

"" Create custom syntax file based on tags.
"" See :help tag-highlight.
"command! TagsSyntax !ctags -R --c-kinds=gstu --c++-kinds=+c -o- | awk 'BEGIN{printf("syntax keyword Type ")}{printf("\%s ", $1)}END{print "\n"}' > .tags.vim;
"" Process all tags related commands.
"command! Tags exe 'TagsUpdate' | exe 'TagsSyntax' | source .tags.vim
""TODO: Add highlighting for other kinds of tags.

" Opens the definition in a vertical split.
" <C-w><C-]> is the default for the same in a horizontal split.
map <C-]>       :exec("tjump "  . expand("<cword>"))<CR>
map <C-w><C-]>  :exec("stjump " . expand("<cword>"))<CR>
map <C-v><C-]>  :vsp <CR>:exec("tjump ".expand("<cword>"))<CR>

" Indentation =========================================={{{2

set textwidth=80

command! IndentGoogle      set   expandtab shiftwidth=2 tabstop=2 cinoptions=(0,w1,i4,W4,l1,g1,h1,N-s,t0
command! IndentLinuxKernel set noexpandtab shiftwidth=8 tabstop=8 cinoptions=(0,w1,i4,W4,l1,g1,h1,N-s,t0,:0
command! IndentStandard IndentGoogle

" Set the default indentation.
IndentStandard


""  Show indentation guides.
"set list listchars=tab:\.\

"" Override indentation based on the path.
"command! IndentStandard set et ts=2 sw=2 cino=(0,W4,l1,g1,h1,N-s,t0
"command! IndentEDK2 set et ts=2 sw=2 cino=(0,W4,l1,g1,h1,N-s,t0
"" Linux Kernel style.
"augroup LinuxKernel
"  autocmd BufRead,BufEnter /work/linux/* IndentLinuxKernel
"augroup END
"augroup KernelGit
"  autocmd BufRead,BufEnter /work/linux/git/* set tags+=/work/linux/git/.tags
"augroup END
"augroup EDK2
"  autocmd BufRead,BufEnter */edk2/* IndentEDK2
"augroup END

" Misc commands ========================================{{{2

" Insert current date.
imap <leader>date <C-R>=strftime('%Y-%m-%d')<CR>
nmap <leader>date i<C-R>=strftime('%Y-%m-%d')<CR><Esc>

" Spread parenthesis enclosed arguments, one on each line.
map <F9> vi(:s/,\s*\([^$]\)/,\r\1/g<CR>vi(=f(%l

"Easy paste of the search pattern without word boundaries.
imap <C-e>/ <C-r>/<Esc>:let @z=@/<CR>`[v`]:<C-u>s/\%V\\<\\|\\>//g<CR>:let @/=@z<CR>a

" Automatically close the pop-up windown on move.
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Background compilation ==================================================={{{1
let g:BgCompilation_res = '/tmp/vim.compilation.res'
let s:BgCompilation_command = 'silent !' . &makeprg
command! -nargs=* -complete=dir Make call Async(s:BgCompilation_command, 'BgCompilationStart()', 'BgCompilationDone()', g:BgCompilation_res, <f-args>)
function! BgCompilationStart()
  echohl Error | echo 'Running background compilation...' | echohl None
endfunction
function! BgCompilationDone()
  exec('cgetfile' . g:BgCompilation_res)
  echohl Error | echo "Background compilation done." | echohl None
endfunction


" Command line ============================================================={{{1

" Pressing shift-; takes too much time.
noremap ; :
" But the ';' key to re-execute the latest find command is useful
noremap - ;
noremap _ ,

" %% expands to the path of the current file.
cabbr <expr> %% expand('%:p:h')

" Easy quote of the searched pattern in command line.
cmap <C-e>/ "<C-r>/"

" Moving around maps =============={{{3

" Make <C-N> and <C-P> take the beginning of the line into account.
cmap <C-n> <Down>
cmap <C-p> <Up>

" Remap keys to move like in edit mode.
cnoremap <C-j> <C-N>
cnoremap <C-k> <C-P>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-b> <C-Left>
cnoremap <C-w> <C-Right>
cnoremap <C-x> <Del>








" .vimrc specific options =================================================={{{1
" vim: set foldmethod=marker:
