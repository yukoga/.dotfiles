" Diagnostics
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_virtual_text_enabled = 1
let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '‼'}
let g:lsp_signs_information = {'text': 'i'}
let g:lsp_signs_hint = {'text': '?'}
let g:lsp_virtual_text_prefix = " ‣ "
let g:lsp_diagnostics_float_cursor = 0
let g:lsp_diagnostics_echo_delay = 200

" Highlight
let g:lsp_highlights_enabled = 0
let g:lsp_highlight_references_enabled = 0

" Floating window
let g:lsp_preview_float = 1
augroup LspFloatMapping
    autocmd!
    autocmd User lsp_float_opened nmap <buffer> <silent> <esc> <Plug>(lsp-preview-close)
    autocmd User lsp_float_closed nunmap <buffer> <esc>
augroup END

if (executable('pyls'))
    let s:pyls_path = fnamemodify(g:python3_host_prog, ':h') . '/'. 'pyls'
    let s:pyls_config = {'pyls': {'plugins': {
   \   'pycodestyle': {'enabled': v:true},
   \   'pydocstyle': {'enabled': v:false},
   \   'pylint': {'enabled': v:false},
   \   'flake8': {'enabled': v:true},
   \   'jedi_definition': {
   \     'follow_imports': v:true,
   \     'follow_builtin_imports': v:true,
   \   },
   \ }}}
    augroup LspPython
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
           \ 'name': 'pyls',
           \ 'cmd': { server_info -> [s:pyls_path] },
           \ 'allowlist': ['python'],
           \ 'workspace_config': s:pyls_config
           \})
    augroup END
endif

" see also: https://github.com/golang/tools/blob/master/internal/lsp/source/options.go
if executable('gopls')
    augroup LspGo
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
           \ 'name': 'gopls',
           \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
           \ 'allowlist': ['go'],
           \ 'workspace_config': {'gopls': {
           \     'completionDocumentation': v:true,
           \     'usePlaceholders': v:true,
           \     'deepCompletion': v:true,
           \     'fuzzyMatching': v:true,
           \     'caseSensitiveCompletion': v:false,
           \     'completeUnimported': v:true,
           \     'staticcheck': v:true,
           \     'watchFileChanges': v:true,
           \     'hoverKind': 'FullDocumentation',
           \   }},
           \ })
    augroup END
endif

if executable('typescript-language-server')
    augroup LspTypeScript
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
       \ 'name': 'javascript support using typescript-language-server',
       \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
       \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
       \ 'allowlist': ['javascript', 'javascript.jsx', 'javascriptreact', 'typescript', 'typescript.tsx'],
       \ 'blocklist': ['vue'],
       \ })
        augroup END
endif

if executable('clangd')
    augroup LspClangd
      autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
        augroup END
endif

if executable('sqls')
    augroup LspSqls
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'sqls',
        \   'cmd': {server_info->['sqls', '-log', expand('~/sqls.log'), '-trace', '-config', expand('~/.config/sqls/config.yml')]},
        \   'allowlist': ['sql'],
        \   'workspace_config': {
        \     'sqls': {
        \       'connections': [
        \         {
        \           'driver': 'mysql',
        \           'dataSourceName': 'root:root@tcp(127.0.0.1:3306)/world',
        \         },
        \       ],
        \     },
        \   },
        \ })
    augroup END
endif

if executable('vls')
    augroup LspVls
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
       \ 'name': 'vue-language-server',
       \ 'cmd': {server_info->['vls']},
       \ 'allowlist': ['vue'],
       \ 'blocklist': ['javascript', 'javascript.jsx', 'javascriptreact', 'typescript', 'typescript.tsx'],
       \ 'initialization_options': {
       \     'config': {
       \         'html': {},
       \          'vetur': {
       \              'validation': {}
       \          }
       \     }
       \ },
       \ })
    augroup END
endif

augroup LspEnable
    autocmd!
    autocmd BufWinEnter *.go   :call lsp#enable()
    autocmd BufWinEnter *.py   :call lsp#enable()
    autocmd BufWinEnter *.ts   :call lsp#enable()
    autocmd BufWinEnter *.js   :call lsp#enable()
    autocmd BufWinEnter *.vue  :call lsp#enable()
    autocmd BufWinEnter *.c    :call lsp#enable()
    autocmd BufWinEnter *.h    :call lsp#enable()
    autocmd BufWinEnter *.cpp  :call lsp#enable()
augroup END

" augroup LspAutoFormatting
"     autocmd!
"     autocmd BufWritePre *.go silent! LspDocumentFormatSync
" augroup END

" Key bindings
nnoremap <C-]> :<C-u>LspDefinition<CR>
nnoremap <C-w><C-]> :<C-u>vertical LspDefinition<CR>
nnoremap t<C-]> :<C-u>tab LspDefinition<CR>
nnoremap K :<C-u>LspHover<CR>
nnoremap <silent> <LocalLeader>K :<C-u>LspPeekDefinition<CR>
nnoremap <silent> <LocalLeader>R :<C-u>LspRename<CR>
nnoremap <silent> <LocalLeader>n :<C-u>LspReferences<CR>
nnoremap <silent> <LocalLeader>f :<C-u>LspDocumentDiagnostics<CR>
nnoremap <silent> <LocalLeader>s :<C-u>LspDocumentFormat<CR>
nnoremap <silent> <LocalLeader>i :<C-u>LspImplementation<CR>
set omnifunc=lsp#complete
