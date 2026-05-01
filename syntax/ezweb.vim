" ~/.vim/pack/plugins/start/vim-ezweb/syntax/ezweb.vim
if exists("b:current_syntax")
  finish
endif

" --- 1. Basic Directives ---
syn cluster ezwebDirectives contains=ezwebDirectiveEscape,ezwebDirectiveSection,ezwebDirectiveNumbered,ezwebDirectiveInclude,ezwebDirectiveIndex

syn match ezwebDirectiveEscape "^@@"
syn match ezwebDirectiveSection "^@\*.*$"
syn match ezwebDirectiveNumbered "^@[ \t].*$"
syn match ezwebDirectiveInclude "^@i .*$"
syn match ezwebDirectiveIndex "^@x .*$"

" Global fallbacks (Only trigger if we are OUTSIDE a known language zone)
syn match ezwebDirectiveChunk "^@[od] .*$"
syn match ezwebDirectiveLangDef "^@l .*$"

hi def link ezwebDirectiveEscape    Special
hi def link ezwebDirectiveSection   Title
hi def link ezwebDirectiveNumbered  Statement
hi def link ezwebDirectiveInclude   Include
hi def link ezwebDirectiveIndex     Identifier
hi def link ezwebDirectiveChunk     Macro
hi def link ezwebDirectiveLangDef   Type


" --- 2. Stateful Language Zones ---
" Add any languages you need here. The string must match Vim's internal filetype name.
let s:languages = get(g:, 'ezweb_languages', ['haskell', 'markdown', 'c', 'cpp', 'python', 'sh'])
let s:bcs = exists('b:current_syntax') ? b:current_syntax : ''

for s:lang in s:languages
  " Safely load the syntax rules without aborting the loop if the file is missing
  unlet! b:current_syntax
  silent! exe 'syn include @ezwebLang_' . s:lang . ' syntax/' . s:lang . '.vim'

  " Zone starts at `@l <lang>`
  " \c makes it case-insensitive, \> ensures word boundary, .* catches trailing spaces
  exe 'syn region ezwebZone_' . s:lang . ' start="^\s*@l\s\+\c' . s:lang . '\>.*$" end="^\ze\s*@l\s\+" contains=@ezwebDirectives,ezwebChunk_' . s:lang . ',ezwebDirectiveLang_' . s:lang

  " Highlight the @l directive specifically within its own zone
  exe 'syn match ezwebDirectiveLang_' . s:lang . ' "^\s*@l\s\+\c' . s:lang . '\>.*$" contained'
  exe 'hi def link ezwebDirectiveLang_' . s:lang . ' Type'

  " The Code Chunk
  " keepend is CRITICAL here: it forces the region to terminate exactly at the empty line,
  " preventing inner syntax rules from accidentally consuming the boundary.
  exe 'syn region ezwebChunk_' . s:lang . ' matchgroup=ezwebDirectiveChunk start="^@[od]\s.*$" end="^$" contained keepend contains=@ezwebLang_' . s:lang
endfor

" Restore original syntax state
if s:bcs != ''
  let b:current_syntax = s:bcs
else
  let b:current_syntax = "ezweb"
endif
