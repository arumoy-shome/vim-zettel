function! s:create_notes_dir() abort
  let l:choice = confirm("Create notes directory " . g:zettel_dir . " ?", "&Yes\n&No")

  if choice == 1
    call mkdir(g:zettel_dir, "p")
    echomsg "Notes directory successfully created."
    return 1
  endif

  echoerr "Notes directory not created."
endfunction

function! s:new_note_id(title) abort
  if len(matchstr(a:title, '\v\s'))
    let l:title = join(split(a:title, '\v\s'), "-")
  elseif len(a:title)
    let l:title = a:title
  endif

  if exists("l:title")
    return strftime("%Y%m%d%H%M%S") . "-" . l:title
  else
    return strftime("%Y%m%d%H%M%S")
endfunction

function! s:insert_title() abort
  call append(0, "# " . expand("%:t:r"))
endfunction

function! zettel#new_note(split, title) abort
  if isdirectory(g:zettel_dir)
    let l:note_name = g:zettel_dir . "/" . s:new_note_id(a:title) . ".md"

    if a:split == "h"
      execute "split " . l:note_name
    elseif a:split == "v"
      execute "vsplit" . l:note_name
    elseif a:split == "t"
      execute "tabedit" . l:note_name
    else
      execute "edit" . l:note_name
    endif
  else
    if s:create_notes_dir()
      call zettel#new_note(a:split, a:title)
    endif
  endif

  call s:insert_title()
endfunction
