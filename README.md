# ezweb

A literate programming system.

## Directives

Directives must appear at the start of a line or they are ignored.

| directive | description |
| --- | --- |
| `@@`                                | escapes the `@` character       |
| `@*` _title text_`.` _other text_ ... | titled numbered section         |
| `@`  _text_ ...                     | numbered section                |
| `@i` _/path/to/include.file_        | include file                    |
| `@x` _identifier_ ...               | index these identifiers         |
| `@l` _language_                     | set chunk syntax language       |
| `@o` _/path/to/output.file_         | start output file chunk         |
| `@d` _chunk name_                   | start chunk definiti            |

## Chunks

The `@o` and `@d` directives begin code chunks.
Code chunks are terminated by an empty line.

## vim-ezweb

The vim mode for ezweb should highlight all directive lines,
and should syntax-highlight all code chunks with the most recent
language (specified by the `@l` directive).
