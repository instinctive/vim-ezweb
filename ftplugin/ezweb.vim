let b:ezweb_lang = ''
for s:line in getline(1, 50)
  let s:m = matchstr(s:line, '^@l \zs\w\+')
  if s:m != ''
    let b:ezweb_lang = s:m
    break
  endif
endfor
