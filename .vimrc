" ==================================================
"                Misc Setup Scripting
" ==================================================

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal')
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" Install vim-plug if not found 
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" ==================================================
"                     Plugins
" ==================================================

call plug#begin()

"=== Utility ===
Plug 'junegunn/vim-plug'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'liuchengxu/vim-which-key'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdcommenter'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'rhysd/vim-healthcheck'
Plug 'tpope/vim-fugitive'

"=== Themes ===
Plug 'morhetz/gruvbox' 

call plug#end()

" ==================================================
"                  Configurations 
" ==================================================

set number
set showcmd
set spr
set smarttab
set shiftwidth=4
set nowrap
let g:lsp_diagnostics_enabled = 0


" Workaround to register escape char for alt key as alt key
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw

set timeout ttimeoutlen=50

let vimDir = '$HOME/.vim'
if stridx(&runtimepath, expand(vimDir)) == -1
  " vimDir is not on runtimepath, add it
  let &runtimepath.=','.vimDir
endif

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

" Set color scheme
set background=dark
autocmd vimenter * ++nested colorscheme gruvbox

" ==================================================
"                    Key Binds
" ==================================================
"
" TODO quick access to vimrc with commands. 
" TODO fzf default to opening a new buffer.
" TODO misc customization shit leader menu

" leader key
noremap <Space> <Nop>
map <Space> <Leader>

" Ctrl + S = save file
noremap <C-S> <Nop>
inoremap <C-S> <Nop>
map <C-S> <Esc>:w<CR>
imap <C-S> <Esc>:w<CR>

" move lines up and down
noremap <A-k> :move -2<CR>
noremap <A-j> :move +1<CR>
noremap <A-up> :move -2<CR>
noremap <A-down> :move +1<CR>

" prevent ctrl z typo from crashing vim
noremap <C-z> <Nop>
inoremap <C-z> <Nop>
noremap <C-Z> <Nop>
inoremap <C-Z> <Nop>

" conflicting keybind with fugitive
noremap g? <Nop>

" auto close braces and parenthesis
"inoremap " ""<left>
"inoremap ' ''<left>
"inoremap ( ()<left>
"inoremap [ []<left>
"inoremap { {}<left>
"inoremap {<CR> {<CR>}<ESC>O
"inoremap {;<CR> {<CR>};<ESC>O

" Enter to accept coc suggestion
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" ==================================================
"                  Plugin: WhichKey
" ==================================================

nnoremap <silent> <leader> :silent WhichKey ' '<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual ' '<CR>

let g:which_key_map =  {}
let g:which_key_sep = ': '

set timeoutlen=250
let g:which_key_use_floating_win = 1

" Single mappings
let g:which_key_map['/'] = [ '<Plug>NERDCommenterToggle'        , 'comment' ]
let g:which_key_map['f'] = [ ':Files'                           , 'search files' ]
let g:which_key_map['e'] = [ ':30Lexplore'                      , 'file explorer (NERDTree)']
let g:which_key_map['r'] = [ ':RG'                              , 'ripgrep' ]
let g:which_key_map['t'] = [ ':term'                            , 'terminal']

let g:which_key_map.C = {
      \ 'name' : '+configuration',
      \ 'v' : [':tabnew $MYVIMRC'                                                          , 'open vimrc'],
      \ 'c' : [':Colors'                                                                   , 'colors'],
      \}
let g:which_key_map.g = {
      \ 'name' : '+goto',
      \ 'd' : ['<plug>(lsp-definition)'              , 'definition'],
      \ 's' : ['<plug>(lsp-document-symbol-search)'  , 'doc symbol search'],
      \ 'S' : ['<plug>(lsp-workspace-symbol-search)' , 'ws search symbol'],
      \ 'r' : ['<plug>(lsp-references)'              , 'references'],
      \ 'i' : ['<plug>(lsp-implementation)'          , 'implementation'],
      \ 't' : ['<plug>(lsp-type-definition)'         , 'type definition'],
  \ }

let g:which_key_map.c = {
     \ 'name' : '+code_actions',
     \ 'a' : [':LspCodeAction'    , 'code actions'],
     \ 'r' : [':LspRename'        , 'rename symbol'],
  \ }
    "nmap <buffer> <leader>rn <plug>(lsp-rename)
    "nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    "nmap <buffer> ]g <plug>(lsp-next-diagnostic)
" Find
let g:which_key_map.f = {
      \ 'name' : '+fuzzyfinder',
      \ 'f' : [':Files'           , 'files'],
      \ 'h' : [':Helptags'        , 'help'],
      \ 'm' : [':Maps'            , 'mappings'],
      \ 'c' : [':Commands'        , 'commands'],
      \ 'H' : [':History'         , 'history'],
      \ 'r' : [':RG'              , 'rip grep'],
      \ 'b' : [':BLines'          , 'current buffer'],
      \ 'B' : [':Lines'           , 'all buffers'],
      \}


" s is for search
let g:which_key_map.s = {
      \ 'name' : '+search' ,
      \ '/' : [':History/'                 , 'history'],
      \ ';' : [':Commands'                 , 'commands'],
      \ 'a' : [':Ag'                       , 'text Ag'],
      \ 'b' : [':BLines'                   , 'current buffer'],
      \ 'B' : [':Buffers'                  , 'open buffers'],
      \ 'c' : [':Commits'                  , 'commits'],
      \ 'C' : [':BCommits'                 , 'buffer commits'],
      \ 'f' : [':Files'                    , 'files'],
      \ 'g' : [':GFiles'                   , 'git files'],
      \ 'G' : [':GFiles?'                  , 'modified git files'],
      \ 'h' : [':History'                  , 'file history'],
      \ 'H' : [':History:'                 , 'command history'],
      \ 'l' : [':Lines'                    , 'lines'] ,
      \ 'm' : [':Marks'                    , 'marks'] ,
      \ 'M' : [':Maps'                     , 'normal maps'] ,
      \ 'p' : [':Helptags'                 , 'help tags'] ,
      \ 'P' : [':Tags'                     , 'project tags'],
      \ 's' : [':CocList snippets'         , 'snippets'],
      \ 'S' : [':Colors'                   , 'color schemes'],
      \ 't' : [':Rg'                       , 'Rg text'],
      \ 'T' : [':BTags'                    , 'buffer tags'],
      \ 'w' : [':Windows'                  , 'search windows'],
      \ 'y' : [':Filetypes'                , 'file types'],
      \ 'z' : [':FZF'                      , 'FZF'],
      \ }

" P is for vim-plug
let g:which_key_map.p = {
      \ 'name' : '+plug' ,
      \ 'i' : [':PlugInstall'             , 'install'],
      \ 'u' : [':PlugUpdate'              , 'update'],
      \ 'c' : [':PlugClean'               , 'clean'],
      \ 's' : [':source ~/.vimrc'         , 'source vimrc'],
      \ }

" Register which key map
call which_key#register(' ', "g:which_key_map")


" ==================================================
"                  Plugin: lsp 
" ==================================================
 if executable('pylsp')
    " pip install python-lsp-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ })
endif
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
