if exists("g:loaded_vim_zettel")
  finish
endif
let g:loaded_vim_zettel = 1

if !exists("g:zettel_dir")
  let g:zettel_dir = expand("$HOME/zettel")
endif

function! s:define_commands() abort
  command -nargs=? Zet :call zettel#new_note("", <q-args>)
  command -nargs=? SZet :call zettel#new_note("h", <q-args>)
  command -nargs=? VZet :call zettel#new_note("v", <q-args>)
  command -nargs=? TZet :call zettel#new_note("t", <q-args>)
  if exists(":CommandT")
    command CommandTZettel :CommandT ~/zettel
  endif
endfunction

function! s:define_bindings() abort
  if exists(":CommandTZettel")
    nmap <silent> <C-n> :CommandTZettel<CR>
  endif
endfunction

augroup VimZettel
  autocmd!
  " NOTE: that autocmds do not allow for dynamic {pat} so this autocmd needs to
  " be overridden in user config.
  " GOTCHA: original pwd not preserved if multiple note windows are opened first
  " thing after starting vim.
  autocmd BufWinEnter $HOME/zettel/*.md if getcwd() !~ g:zettel_dir |
        \ execute "lcd" . g:zettel_dir | endif
  autocmd BufWinLeave $HOME/zettel/*.md if getcwd() !~ g:zettel_dir |
        \ execute "lcd -" | endif
augroup END

call s:define_commands()
call s:define_bindings()
