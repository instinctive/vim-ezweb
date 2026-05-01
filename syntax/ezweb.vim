" ~/.vim/pack/plugins/start/vim-ezweb/syntax/ezweb.vim
if exists("b:current_syntax")
  finish
endif

" --- 1. Basic Directives ---
" Cluster of all standalone directives so they can be matched globally
syn cluster ezwebDirectives contains=ezwebDirectiveEscape,ezwebDirectiveSection,ezwebDirectiveNumbered,ezwebDirectiveInclude,ezwebDirectiveIndex

" Match individual directives (strictly anchored to the start of the line)
syn match ezwebDirectiveEscape "^@@"
syn match ezwebDirectiveSection "^@\*.*$"
syn match ezwebDirectiveNumbered "^@[ \t].*$"
syn match ezwebDirectiveInclude "^@i .*$"
syn match ezwebDirectiveIndex "^@x .*$"

" Provide default fallback highlighting if a chunk/lang is used outside a known zone
syn match ezwebDirectiveChunk "^@[od] .*$"
syn match ezwebDirectiveLangDef "^@l .*$"

" --- 2. Highlight Links ---
hi def link ezwebDirectiveEscape    Special
hi def link ezwebDirectiveSection   Title
hi def link ezwebDirectiveNumbered  Statement
hi def link ezwebDirectiveInclude   Include
hi def link ezwebDirectiveIndex     Identifier
hi def link ezwebDirectiveChunk     Macro
hi def link ezwebDirectiveLangDef   Type


" --- 3. Stateful Language Zones ---
" Define the languages you want to support. You can override this in your .vimrc
" by setting: let g:ezweb_languages = ['haskell', 'markdown', 'c', 'python']
let s:languages = get(g:, 'ezweb_languages', ['haskell', 'markdown', 'python', 'sh'])

for s:lang in s:languages
  " Attempt to load the syntax file for the language safely
  try
    unlet! b:current_syntax
    exe 'syn include @ezwebLang_' . s:lang . ' syntax/' . s:lang . '.vim'
  catch
    continue
  endtry

  " Create a state Zone. It begins at `@l <lang>` and ends right before (\ze) the next `@l`
  exe 'syn region ezwebZone_' . s:lang . ' start="^@l\s\+' . s:lang . '\s*$" end="^\ze@l\s\+" contains=@ezwebDirectives,ezwebChunk_' . s:lang . ',ezwebDirectiveLang_' . s:lang

  " Highlight the @l directive specifically within its own zone
  exe 'syn match ezwebDirectiveLang_' . s:lang . ' "^@l\s\+' . s:lang . '\s*$" contained'
  exe 'hi def link ezwebDirectiveLang_' . s:lang . ' Type'

  " Define the actual code chunk region inside this zone.
  " - matchgroup=ezwebDirectiveChunk: Highlights the @o or @d line itself as a directive.
  " - start="^@[od]\s.*$": Starts on the chunk definition.
  " - end="^$": Terminates strictly on an empty line, per your spec.
  " - contains=@ezwebLang_...: Applies the specific language syntax to the inner body.
  exe 'syn region ezwebChunk_' . s:lang . ' matchgroup=ezwebDirectiveChunk start="^@[od]\s.*$" end="^$" contained contains=@ezwebLang_' . s:lang
endfor

let b:current_syntax = "ezweb"
