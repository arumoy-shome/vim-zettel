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

function! s:populate_qf(list) abort
  " Map file names to format, as understood by 'errorformat' (similar to
  " grepformat)
  " from https://github.com/samoshkin/vim-find-files/blob/master/autoload/find_files/qf.vim#L10
  let l:notes = map(a:list, 'v:val . ":1:" . fnamemodify(v:val, ":.")')
  cgetexpr l:notes
  copen
  call setqflist([], 'r', {'title': 'zettel - ' . getcwd()})
endfunction

function! zettel#ls(scope, note) abort
  if !len(s:notes)
    echomsg "No notes found, create a note first!"
    return
  endif

  if a:scope == 'all'
    let l:notes = s:notes
  elseif a:scope == 'main'
    let l:notes = split(globpath(g:zettel_dir, '????????????00.md'), "\n")
  elseif a:scope == 'sub'
    if !len(a:note)
      echomsg "Parent note required!"
      return
    endif

    let l:note_id = matchstr(a:note, s:note_id_pattern)
    let l:node_id = l:note_id[0:11]
    let l:notes = split(globpath(g:zettel_dir, l:node_id . '??.md'), "\n")
  else
    let l:notes = []
  endif

  if len(l:notes)
    call s:populate_qf(l:notes)
  else
    echomsg "No notes found."
  endif
endfunction
