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
endfunction

call s:define_commands()
