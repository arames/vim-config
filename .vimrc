" .vimrc
" by A. Rames <alexandre.rames@gmail.com>
"
" The configuration is targeted at and has only been tested on terminal vim.

if has('nvim')
  let s:dir_vim_config = expand("~/.config/nvim")
else
  let s:dir_vim_config = expand("~/.vim")
endif

if !has('nvim')
  " Use Vim settings, rather then Vi settings.
  " This must be first, because it changes other options as a side effect.
  " Neovim has removed this.
  set nocompatible
endif

if !has('nvim')
  " This has been removed in neovim.
  set shell=/bin/bash
endif

set encoding=utf-8
set history=10000               " Keep 10000 lines of command line history.
set mouse=a                     " Enable the mouse (eg. for resizing).
set ignorecase                  " Ignore case in search by default.
set smartcase                   " Case insensitive when not using uppercase.
set wildignore=*.bak,*.o,*.e,*~ " Wildmenu: ignore these extensions.
set wildmenu                    " Command-line completion in an enhanced mode.
set wildmode=list:longest       " Complete longest common string, then list.
set showcmd                     " Display incomplete commands.

let s:hostname = substitute(system('hostname'), '\n', '', '')
if s:hostname == "achille"
  let mapleader = "\"
endif

" Load/save and automatic backup ==========================================={{{1


let &directory=s:dir_vim_config.'/swap'
let &viewdir=s:dir_vim_config.'/view'
let &backupdir=s:dir_vim_config.'/backup'
let &undodir=s:dir_vim_config.'/undo'

" Create directories if they don't already exist.
if !isdirectory(&directory)
  exec "silent !mkdir -p " . &directory
  exec "silent !chmod 750 " . &directory
endif
if !isdirectory(&viewdir)
  exec "silent !mkdir -p " . &viewdir
  exec "silent !chmod 750 " . &viewdir
endif
if !isdirectory(&backupdir)
  exec "silent !mkdir -p " . &backupdir
  exec "silent !chmod 750 " . &backupdir
endif
if !isdirectory(&undodir)
  exec "silent !mkdir -p " . &undodir
  exec "silent !chmod 750 " . &undodir
endif


" Backup files.
set backup
" Keep a history of the edits so changes from a previous session can be
" undone.
set undofile

" Automatically save and load views.
autocmd BufWinLeave,BufWrite *.* mkview
autocmd BufWinEnter *.* silent! loadview

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


" Plugins =================================================================={{{1

" Use Vim-plug to manage the plugins. See https://github.com/junegunn/vim-plug
" for details.

call plug#begin(s:dir_vim_config.'/plugged')

Plug 'arames/vim-diffgofile', {
  \ 'do': 'cd ftplugin && ln -s diff_gofile.vim git_diffgofile.vim',
  \ 'for': ['diff', 'git']
  \ }
let g:diffgofile_goto_existing_buffer = 1
autocmd FileType diff nnoremap <buffer> <C-]> :call DiffGoFile('n')<CR>
autocmd FileType diff nnoremap <buffer> <C-v><C-]> :call DiffGoFile('v')<CR>
autocmd FileType git nnoremap <buffer> <C-]> :call DiffGoFile('n')<CR>
autocmd FileType git nnoremap <buffer> <C-v><C-]> :call DiffGoFile('v')<CR>

" Case-sensitive search and replace (and more!).
Plug 'tpope/vim-abolish'

" Quickly move around.
Plug 'Lokaltog/vim-easymotion'
let g:EasyMotion_leader_key = ','
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'

" Easy parenthesis and co.
Plug 'tpope/vim-surround'

" Fuzzy finder.
Plug 'junegunn/fzf'
nmap <C-p> :FZF<CR>

" Provide argument objects.
Plug 'inkarkat/argtextobj.vim'

" Word highlighting.
Plug 'inkarkat/vim-mark'
" Dependency of `inkarkat/vim-mark`.
Plug 'inkarkat/vim-ingo-library'

" Git integration.
Plug 'tpope/vim-fugitive'
" Display lines git diff status when editing a file in a git repository.
Plug 'airblade/vim-gitgutter'

"" Switch between header and implementation files.
"Plug 'vim-scripts/a.vim'
"nnoremap <leader>hh :A<CR>
"
"Plug 'scrooloose/nerdtree'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" `clang-format` integration.
Plug 'kana/vim-operator-user' " Required by `vim-clang-format`.
Plug 'rhysd/vim-clang-format'
autocmd FileType c,cpp,objc map <buffer><Leader>f <Plug>(operator-clang-format)

if has('python')
  Plug 'Valloric/YouCompleteMe', {
  \ 'do': './install.py --clang-completer'
  \ }
  " A few YCM configuration files are whitelisted in `~/.vim.ycm_whitelist`. For
  " others, ask for confirmation before loading.
  let g:ycm_confirm_extra_conf = 1
  if filereadable(resolve(expand("~/.config/nvim/ycm_whitelist")))
    " This file should look something like:
    "   let g:ycm_extra_conf_globlist = ['path/to/project_1/*', 'path/to/project_2/*' ]
    source ~/.config/nvim/ycm_whitelist
  endif
  " TODO: remove: nnoremap <F12> :silent YcmForceCompileAndDiagnostics<CR>
  " Don't use <Tab>. <C-n> and <C-p> are better, and we use tabs in vim-sem-tabs.
  let g:ycm_key_list_select_completion = ['<Down>']
  let g:ycm_key_list_previous_completion = ['<Up>']

  " Fast access to YcmCompleter
  cabbrev ycmc YcmCompleter
  nnoremap ,g  :YcmCompleter GoTo<CR>
  nnoremap ,gg  :YcmCompleter GoTo<CR>
  nnoremap ,gh :YcmCompleter GoToDeclaration<CR>
  nnoremap ,gc :YcmCompleter GoToDefinition<CR>

  " TODO: This bugs when editting in the command-editing window (<C-F> in
  " command mode).
  "" Automatically close the pop-up windown on move.
  "autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
  "autocmd InsertLeave * if pumvisible() == 0|pclose|endif
endif

" Highlight backtrace.
" Useful to edit color schemes.
Plug 'gerw/vim-HiLinkTrace'
nmap <F10> :HLT<CR>

" Personal wiki
Plug 'vim-scripts/vimwiki'
" Use the markdown syntax
let g:vimwiki_list = [{'path': '/Users/arames/Library/Mobile Documents/com~apple~icloud~applecorporate/Documents/wiki',
                     \ 'syntax': 'markdown', 'ext': '.md'}]

Plug 'christoomey/vim-tmux-navigator'


"" Unused plugins ===================={{3
"
"" Quick file find and open.
"Plug 'kien/ctrlp.vim'
"
""" Easy commenting and uncommenting.
""Plug 'tpope/vim-commentary'
""
"" Asynchronous grep.
"Plug 'arames/vim-async-grep'
""
""" Allow opening a file to a specific line with 'file:line'
""Plug 'bogado/file-line'
""
""" Easy access to an undo tree.
""Plug 'mbbill/undotree'
""
""" Diff between selected blocks of code.
""Plug 'AndrewRadev/linediff.vim'
""
""" Languages syntax.
""Plug 'dart-lang/dart-vim-plugin'
""Plug 'plasticboy/vim-markdown'
""Plug 'hynek/vim-python-pep8-indent'
""
""" Easy alignment.
""Plug 'junegunn/vim-easy-align'
""vmap <Enter> <Plug>(EasyAlign)
"
"""Plug 'Rip-Rip/clang_complete'
"""let g:clang_library_path='/usr/lib/llvm-3.2/lib/'
""
"""" Asynchronous commands
"""Plug 'tpope/vim-dispatch'
"""Plug 'vim-scripts/Align'
"""" Need to work out how to get it working for more complex projects.
""""Plug 'scrooloose/syntastic'


call plug#end()


"" Presentation ============================================================={{{1
"
"" Uncommenting this will allow specifying 24bit colors. The very simple color
"" scheme used does not need this.
""if has('nvim')
""  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
""endif
"
if !has('nvim')
  " neovim looks at the environment variable `$TERM`, which is expected to
  " contain `256color`.
  set t_Co=256                  " 256 colors.
endif
syntax on                       " Enable syntax highlighting.
colorscheme quiet
set ruler                       " Show the cursor position all the time.
set winminheight=0              " Minimum size of splits is 0.
set nowrap                      " Do not wrap lines.
set scrolloff=5                 " Show at least 5 lines around the cursor.
set noerrorbells                " No bells.
"let &sbr = nr2char(8618).' '    " Show ↪ at the beginning of wrapped lines.

set number                      " Display line numbers.
"" Display relative line numbers in normal mode and absolute line numbers
"" in insert mode.
"set relativenumber              " Display relative line numbers.
"autocmd InsertEnter * :set number
"autocmd InsertLeave * :set relativenumber
"" Always display absolute line numbers in the quick-fix windows for easy
"" 'cc <n>' commands.
"autocmd BufRead * if &ft == "qf" | setlocal norelativenumber | endif
"
"
"
"" Custom color groups =================================={{{2
"highlight MessageWarning ctermbg=88 guibg=#902020
"highlight MessageDone    ctermbg=22
"
" Editing =================================================================={{{1

set backspace=indent,eol,start   " Backspacing over everything in insert mode.
set hlsearch                     " Highlight the last used search pattern.
set showmatch                    " Briefly display matching bracket.
set matchtime=5                  " Time (*0.1s) to show matching bracket.
set incsearch                    " Perform incremental searching.
set tags=.tags
if has('nvim')
  set inccommand=split           " Show incremental results of substitute.
endif

" Turn off last search highlighting
nmap <Space> :nohlsearch<CR>

" Move between splits.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


"" Easy bracketing in visual mode.
"" Take care of saving the unnamed register.
"vnoremap <leader>(  :<C-u>let@z=@"<CR>gvs()<Esc>P<Right>%:<C-u>let@"=@z<CR>
"vnoremap <leader>[  :<C-u>let@z=@"<CR>gvs[]<Esc>P<Right>%:<C-u>let@"=@z<CR>
"vnoremap <leader>{  :<C-u>let@z=@"<CR>gvs{}<Esc>P<Right>%:<C-u>let@"=@z<CR>
"xnoremap <leader>'  :<C-u>let@z=@"<CR>gvs''<Esc>P<Right>%:<C-u>let@"=@z<CR>
"xnoremap <leader>"  :<C-u>let@z=@"<CR>gvs""<Esc>P<Right>%:<C-u>let@"=@z<CR>
"xnoremap <leader>`  :<C-u>let@z=@"<CR>gvs``<Esc>P<Right>%:<C-u>let@"=@z<CR>
"
"nnoremap <F4> :q<CR>
"
"" Completion ==========================================={{{2
"" Display a menu, insert the longest common prefix but don't select the first
"" entry, and display some additional information if available.
"set completeopt=menu,longest,preview
"
"" Grep/tags ============================================{{{2
"
"" Grep in current directory.
set grepprg=grep\ -RHIn\ --exclude=\".tags\"\ --exclude-dir=\".svn\"\ --exclude-dir=\".git\"
"set grepprg=ack
"" Grep for the word under the cursor.
"nnoremap K :Grep "\\<<C-r><C-w>\\>" .<CR>
"nmap <leader>grep K
"" Versions suffixed with `l` for the location list cause vim to wait for keys
"" after `grep`. Provide versions with extra characters to allow skipping the
"" wait.
"nmap <leader>grepc K
"nmap <leader>grep<Space> K
"nmap <leader>grep<CR> K
"" Grep in the current file's path.
"nmap <leader>grepd :Grep "\\<<C-r><C-w>\\>" %:p:h<CR>
"" Grep for the text selected. Do not look for word boundaries.
"vnoremap K "zy:<C-u>Grep "<C-r>z" .<CR>
"vmap <leader>grep K
"vmap <leader>grepd :Grep "\\<<C-r><C-w>\\>" %:p:h<CR>
"
"" Same as above, but for the location list.
"nnoremap <F9> :GrepL "\\<<C-r><C-w>\\>" .<CR>
"nmap <leader>grepl <F9>
"nmap <leader>grepl<Space> <F9>
"nmap <leader>grepl<CR> <F9>
"nmap <leader>grepld :GrepL "\\<<C-r><C-w>\\>" %:p:h<CR>
"vnoremap <F9> "zy:<C-u>GrepL "<C-r>z" .<CR>
"vmap <leader>grepl <F9>
"vmap <leader>grepld :GrepL "\\<<C-r><C-w>\\>" %:p:h<CR>

" Update tags file.

if has('nvim')
  let s:TagsUpdateCommand = 'ctags -o .tags --recurse --c-kinds=+p --c++-kinds=+p --fields=+iaS --extra=+q'
  function! s:TagsUpdateOnExit(job_id, data, event)
    if a:data == 0
      echohl Green | echo "Done building tags." | echohl None
    else
      echohl Error | echo "Building tags failed." | echohl None
    endif
  endfunction
  function! s:TagsUpdateHandler(job_id, data, event)
  endfunction
  let s:TagsUpdateCallbacks = {
  \ 'on_stdout': function('s:TagsUpdateHandler'),
  \ 'on_stderr': function('s:TagsUpdateHandler'),
  \ 'on_exit': function('s:TagsUpdateOnExit')
  \ }
  command! TagsUpdate call jobstart(split(s:TagsUpdateCommand), s:TagsUpdateCallbacks)
else
  command! TagsUpdate silent !ctags -o .tags --recurse --c-kinds=+p --c++-kinds=+p --fields=+iaS --extra=+q
endif

""" Create custom syntax file based on tags.
""" See :help tag-highlight.
""command! TagsSyntax !ctags -R --c-kinds=gstu --c++-kinds=+c -o- | awk 'BEGIN{printf("syntax keyword Type ")}{printf("\%s ", $1)}END{print "\n"}' > .tags.vim;
""" Process all tags related commands.
""command! Tags exe 'TagsUpdate' | exe 'TagsSyntax' | source .tags.vim
"""TODO: Add highlighting for other kinds of tags.
"
"" Opens the definition in a vertical split.
"" <C-w><C-]> is the default for the same in a horizontal split.
nmap <C-]>       :exec("tjump "  . expand("<cword>"))<CR>
nmap <C-w><C-]>  :exec("stjump " . expand("<cword>"))<CR>
nmap <C-v><C-]>  :vsp <CR>:exec("tjump ".expand("<cword>"))<CR>

" Indentation =========================================={{{2

set textwidth=80
set nojoinspaces

" Automatically strip the comment marker when joining automated lines.
set formatoptions+=j
" Recognize numbered lists and indent them nicely.
set formatoptions+=n

command! IndentTab         set noexpandtab shiftwidth=8 tabstop=8 cinoptions=(0,w1,i4,W4,l1,g1,h1,N-s,t0,+4
command! IndentGoogle      set   expandtab shiftwidth=2 tabstop=2 cinoptions=(0,w1,i4,W4,l1,g1,h1,N-s,t0,+4
command! IndentLinuxKernel set noexpandtab shiftwidth=8 tabstop=8 cinoptions=(0,w1,i4,W4,l1,g1,h1,N-s,t0,:0,+4
command! IndentLLVM        set   expandtab shiftwidth=2 tabstop=2 cinoptions=(0,w1,i4,W4,l1,g0,h2,N-s,t0,:0,+4

" Default indentation styles
IndentGoogle
autocmd FileType cpp IndentGoogle
autocmd FileType sh IndentGoogle


"""  Show indentation guides.
""set list listchars=tab:\.\
"
"" Misc commands ========================================{{{2
"
"" Insert current date.
"imap <leader>date <C-R>=strftime('%Y-%m-%d')<CR>
"nmap <leader>date i<C-R>=strftime('%Y-%m-%d')<CR><Esc>
"
"" Spread parenthesis enclosed arguments, one on each line.
"map <F8> vi(:s/,\s*\([^$]\)/,\r\1/g<CR>vi(=f(%l
"
"" Easy paste of the search pattern without word boundaries.
"imap <C-e>/ <C-r>/<Esc>:let @z=@/<CR>`[v`]:<C-u>s/\%V\\<\\|\\>//g<CR>:let @/=@z<CR>a
"
"" Background compilation ==================================================={{{1
"let g:BgCompilation_res = '/tmp/vim.compilation.res'
"let s:BgCompilation_command = 'silent !' . &makeprg
"command! -nargs=* -complete=dir Make call Async(s:BgCompilation_command, 'BgCompilationStart()', 'BgCompilationDone()', g:BgCompilation_res, <f-args>)
"function! BgCompilationStart()
"  echohl MessageWarning | echo 'Running background compilation...' | echohl None
"endfunction
"function! BgCompilationDone()
"  exec('cgetfile' . g:BgCompilation_res)
"  echohl MessageDone | echo "Background compilation done." | echohl None
"endfunction
"
"
" Terminal ================================================================={{{1

if has('nvim')
  tnoremap <C-]> <C-\><C-n>
endif


" Command line ============================================================={{{1

" Pressing shift-; takes too much time!
noremap ; :
" But the ';' key to re-execute the latest find command is useful
noremap - ;
noremap _ ,

" %% expands to the path of the current file.
cabbr <expr> %% expand('%:p:h')
cabbr <expr> $$ expand('%:p')

"" Easy quote of the searched pattern in command line.
"cmap <C-e>/ "<C-r>/"

" Moving around maps

" Make <C-N> and <C-P> take the beginning of the line into account.
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>


"command! NukeTrailingWhitespace :%s/\s\+$//e
"" We could automatcially delete trailing whitespace upon save with
""   autocmd BufWritePre * :%s/\s\+$//e
"" However this becomes annoying when dealing with dirty external projects, when
"" the deletions make it into patches.
"
"
" Projects ================================================================={{{1

augroup metalfe
  autocmd BufRead,BufEnter */metalfe/* IndentLLVM
augroup END

"augroup ART
"  autocmd BufRead,BufEnter */art/* IndentGoogle
"  autocmd BufRead,BufEnter */art/* exec "set tags+=" . substitute(system('git rev-parse --show-toplevel'), '\n', '', 'g') . "/.tags"
"augroup END
"
"augroup VIXL
"  autocmd BufRead,BufEnter */vixl/* IndentGoogle
"augroup END
"
""" Linux Kernel style.
""augroup LinuxKernel
""  autocmd BufRead,BufEnter /work/linux/* IndentLinuxKernel
""augroup END
""augroup KernelGit
""  autocmd BufRead,BufEnter /work/linux/git/* set tags+=/work/linux/git/.tags
""augroup END


" Misc ====================================================================={{{1

"autocmd BufEnter SConstruct setf python
"autocmd BufRead,BufNewFile *.metal setfiletype cpp

"" The following allows using mappings with the 'alt' key in terminals using the
"" ESC prefix (including gnome terminal). Unluckily this does not always play
"" well with macros.
"" The info was found at:
""   http://stackoverflow.com/questions/6778961/alt-key-shortcuts-not-working-on-gnome-terminal-with-vim
""let c='a'
""while c <= 'z'
""  exec "set <A-".c.">=\e".c
""  exec "imap \e".c." <A-".c.">"
""  let c = nr2char(1+char2nr(c))
""endw
""set timeout ttimeoutlen=50



" Deprecated ==============================================================={{{1

" Deprecated configuration items, that may be useful for future reference.

" While useful, I prefer using <C-f> in command-line mode.
"" Remap keys to move like in edit mode.
"cnoremap <C-j> <C-N>
"cnoremap <C-k> <C-P>
"cnoremap <C-h> <Left>
"cnoremap <C-l> <Right>
"cnoremap <C-b> <C-Left>
"cnoremap <C-w> <C-Right>
"cnoremap <C-x> <Del>

"


" .vimrc specific options =================================================={{{1
" vim: set foldmethod=marker:
" nvim: set foldmethod=marker:
