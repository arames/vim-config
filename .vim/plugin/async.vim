" Vim global plugin for asynchronous commands.
" Last Change:	2013 August 1
" Maintainer:	Alexandre Rames <alexandre.rames@gmail.com>
" License:	This file is placed in the public domain.

" Documentation ============================================================{{{1
" This plugin uses '--remote-expr' (available with vim 'clientserver'
" capability) to improve user " interation.
" Introduce an alias in your shell configuration to automatically start vim
" with a servername (automatically suffixed with an index when multiple
" sessions are started).
" Bash example:
"   alias vim="vim --servername vimserver"
"
" The plugin provides a singly Async() function. See its definition for
" details about the parameters, and the example use cases below.

" Example usage ========================================{{{2

" " Build tags in the background.
" let s:TagsUpdate_command = 'silent !ctags -o .tags -R --c-kinds=+p --c++-kinds=+p --fields=+iaS --extra=+q'
" function! TagsUpdateStart()
"   echohl Error | echo "Building tags..." | echohl None
" endfunction
" function! TagsUpdateDone()
"   echohl Error | echo "Done building tags." | echohl None
" endfunction
" command! -nargs=* -complete=dir TagsUpdate call Async(s:TagsUpdate_command, 'TagsUpdateStart()', 'TagsUpdateDone()', '/dev/null', <f-args>)
"
" " Compile in the background and load the error file. Once notified, use
" ':copen' to open the quickfix window.
" " Invoke like the standard ':make', but with ':Make' instead.
" let g:BgCompilation_res = '/tmp/vim.compilation.res'
" let s:BgCompilation_command = 'silent !' . &makeprg
" command! -nargs=* -complete=dir Make call Async(s:BgCompilation_command, 'BgCompilationStart()', 'BgCompilationDone()', g:BgCompilation_res, <f-args>)
" function! BgCompilationStart()
"   echohl Error | echo 'Running background compilation...' | echohl None
" endfunction
" function! BgCompilationDone()
"   exec('cgetfile' . g:BgCompilation_res)
"   echohl Error | echo "Background compilation done." | echohl None
" endfunction
"
" " Grep in the background and load the error file. Once notified, use
" " ':copen' to open the quickfix window.
" " Invoke like the standard ':grep', but with ':Grep' instead.
" let g:BgGrep_res = '/tmp/vim.grep.res'
" let s:BgGrep_command = 'silent !' . &grepprg
" command! -nargs=* -complete=dir Grep call Async(s:BgGrep_command, 'BgGrepStart()', 'BgGrepDone()', g:BgGrep_res, <f-args>)
" function! BgGrepStart()
"   echohl Error | echo 'Running background grep...' | echohl None
" endfunction
" function! BgGrepDone()
"   exec('cgetfile' . g:BgGrep_res)
"   echohl Error | echo "Background grep done." | echohl None
" endfunction


" Plugin code =============================================================={{{1
if exists("g:loaded_async")
  finish
endif
let g:loaded_async = 1

" Execute a:command asynchronously with all extra arguments passed.
" After a:command is started, the function a:command_callback is called. This
" can be used to notify the user.
" The result of a:command is redirected to a:redirection.
" After a:command has completed, the function a:done_callback is called. This
" can be used to notify the user and handle results of the command.
function! Async(command, command_callback, done_callback, redirection, ...)
  if empty(v:servername) || ! has('clientserver')
    exec(a:command . ' ' . join(a:000, ' ') . ' &> ' . a:redirection . ' &')
  else
    exec(a:command . ' ' . join(a:000, ' ') . ' &> ' . a:redirection . ' && 0 &> /dev/null || vim --servername ' . v:servername . ' --remote-expr "' . a:done_callback . '" &>/dev/null &')
  endif
  " The previous commands leave us with a blank screen.
  exec('redraw!')
  exec('call ' . a:command_callback)
endfunction

" file formatting options =================================================={{{1
" vim: set foldmethod=marker:

