function! myspacevim#before() abort
endfunction

function s:EnableTrailingHighlight()
  highlight ExtraWhitespace ctermbg=red guibg=red
  match ExtraWhitespace /\s\+$/
endfunction

function! s:EnableElmAndCljLSP() abort
  let g:LanguageClient_serverCommands = {
    \ 'elm': ['elm-language-server'],
    \ 'clojure': ['clojure-lsp'],
    \ }
  let g:LanguageClient_rootMarkers = {
    \ 'elm': ['elm.json'],
    \ }
  let g:ale_completion_enabled = 1
  let g:ale_linters = { 'elm': ['elm_ls'] }
  let g:ale_sign_column_always = 0
  let g:ale_set_highlights = 0
  let g:ale_close_preview_on_insert = 0
  let g:ale_cursor_detail = 0
endfunction

function! myspacevim#after() abort
  call s:EnableTrailingHighlight()
  call s:EnableElmAndCljLSP()
  set wrap
endfunction
