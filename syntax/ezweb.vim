if exists('b:current_syntax')
  finish
endif

syn match ezwebEscape "^@@"
syn match ezwebTitledSection "^@\*[^.]*\."
syn match ezwebSection "^@[^@*idlox]"
syn match ezwebInclude "^@i .*"
syn match ezwebIndex "^@x .*"
syn match ezwebLang "^@l .*"

hi def link ezwebEscape Special
hi def link ezwebTitledSection Statement
hi def link ezwebSection Special
hi def link ezwebInclude PreProc
hi def link ezwebIndex PreProc
hi def link ezwebLang PreProc
hi def link ezwebChunkStart Special

hi Statement cterm=bold gui=bold

let s:lang_overrides = ['haskell', 'python', 'javascript', 'bash', 'sh']

if b:ezweb_lang != ''
  let s:syndone = ''
  execute 'syn include @ezwebDefault syntax/' . b:ezweb_lang . '.vim'
  unlet! b:current_syntax
  syn region ezwebChunkDefault matchgroup=ezwebChunkStart start="^@o [^:]*$" end="^$"me=e-1 contains=@ezwebDefault keepend
  syn region ezwebChunkDefault matchgroup=ezwebChunkStart start="^@d [^:]*$" end="^$"me=e-1 contains=@ezwebDefault keepend
  let s:syndone = b:ezweb_lang
else
  syn region ezwebChunkDefault matchgroup=ezwebChunkStart start="^@o [^:]*$" end="^$"me=e-1 keepend
  syn region ezwebChunkDefault matchgroup=ezwebChunkStart start="^@d [^:]*$" end="^$"me=e-1 keepend
  let s:syndone = ''
endif

for s:lang in s:lang_overrides
  if s:lang ==# s:syndone
    continue
  endif
  let s:cluster = '@ezwebLang_' . s:lang
  try
    execute 'syn include ' . s:cluster . ' syntax/' . s:lang . '.vim'
    unlet! b:current_syntax
  catch
    continue
  endtry
  execute 'syn region ezwebChunk_' . s:lang
        \ . ' matchgroup=ezwebChunkStart'
        \ . ' start="^@o ' . s:lang . ':.*$"'
        \ . ' end="^$"me=e-1'
        \ . ' contains=' . s:cluster
        \ . ' keepend'
  execute 'syn region ezwebChunk_' . s:lang
        \ . ' matchgroup=ezwebChunkStart'
        \ . ' start="^@d ' . s:lang . ':.*$"'
        \ . ' end="^$"me=e-1'
        \ . ' contains=' . s:cluster
        \ . ' keepend'
endfor

hi def link ezwebChunkDefault Normal

let b:current_syntax = 'ezweb'
