set commentstring=//\ %s

" Disable inserting comment leader after hitting o or O or <Enter>
set formatoptions-=o
set formatoptions-=r

nnoremap <silent> <buffer> <F9> :call <SID>make_or_compile_run_cpp()<CR>

function! s:make_or_compile_run_cpp() abort
  if v:lua.NvimConfig.has_makefile()
    update
    make
  else
    call s:compile_run_cpp()
  endif
endfunction

function! s:compile_run_cpp() abort
  let src_path = expand('%:p:~')
  let src_noext = expand('%:p:~:r')
  " The building flags
  let _flag = '-Wall -Wextra -std=c++17 -O2'

  if executable('g++')
    let prog = 'g++'
  elseif executable('clang++')
    let prog = 'clang++'
  else
    echoerr 'No C++ compiler found on the system!'
  endif
  call s:create_term_buf('h', 20)
  execute printf('term %s %s %s -o %s && %s', prog, _flag, src_path, src_noext, src_noext)
  startinsert
endfunction

function s:create_term_buf(_type, size) abort
  set splitbelow
  set splitright
  if a:_type ==# 'v'
    vnew
  else
    new
  endif
  execute 'resize ' . a:size
endfunction
