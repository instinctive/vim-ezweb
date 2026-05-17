let b:ezweb_lang = ''
for s:line in getline(1, 50)
  let s:m = matchstr(s:line, '^:source-language: \zs\w\+')
  if s:m != ''
    let b:ezweb_lang = s:m
    break
  endif
endfor

set foldmethod=expr
set foldexpr=GetCustomFold(v:lnum)

function! GetCustomFold(lnum)
    let l:line = getline(a:lnum)

    " If line starts exactly with '= ' or '@*', start a level 1 fold
    if l:line =~ '^= \|^@\*'
        return '>1'
    endif

    " Otherwise, keep the fold level of the previous line
    return '='
endfunction
