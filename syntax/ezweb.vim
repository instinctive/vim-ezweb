if exists('b:current_syntax')
  finish
endif

syn match ezwebEscape "^@@"
syn match ezwebTitledSection "^@\*[^.]*\."
syn match ezwebSection "^@[^@*idlox]"
syn match ezwebInclude "^@i .*"
syn match ezwebIndex "^@x .*"
syn match ezwebLang "^@l .*"

syn match ezwebChunkStart "^@o .*" contained
syn match ezwebChunkStart "^@d .*" contained

hi def link ezwebEscape Special
hi def link ezwebTitledSection Statement
hi def link ezwebSection Special
hi def link ezwebInclude PreProc
hi def link ezwebIndex PreProc
hi def link ezwebLang PreProc
hi def link ezwebChunkStart Special

let s:lang_overrides = ['haskell', 'python', 'javascript', 'bash', 'sh']

if b:ezweb_lang != ''
  let s:syndone = ''
  execute 'syn include @ezwebDefault syntax/' . b:ezweb_lang . '.vim'
  unlet! b:current_syntax
  syn region ezwebChunkDefault start="^@o [^:]*$" end="^$"me=e-1 contains=ezwebChunkStart,@ezwebDefault keepend
  syn region ezwebChunkDefault start="^@d [^:]*$" end="^$"me=e-1 contains=ezwebChunkStart,@ezwebDefault keepend
  let s:syndone = b:ezweb_lang
else
  syn region ezwebChunkDefault start="^@o [^:]*$" end="^$"me=e-1 contains=ezwebChunkStart keepend
  syn region ezwebChunkDefault start="^@d [^:]*$" end="^$"me=e-1 contains=ezwebChunkStart keepend
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
        \ . ' start="^@o ' . s:lang . ':.*$"'
        \ . ' end="^$"me=e-1'
        \ . ' contains=ezwebChunkStart,' . s:cluster
        \ . ' keepend'
  execute 'syn region ezwebChunk_' . s:lang
        \ . ' start="^@d ' . s:lang . ':.*$"'
        \ . ' end="^$"me=e-1'
        \ . ' contains=ezwebChunkStart,' . s:cluster
        \ . ' keepend'
endfor

hi def link ezwebChunkDefault Normal

let b:current_syntax = 'ezweb'
