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

" Quality of life
Plug 'liuchengxu/vim-which-key'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'

" Editing Tools
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'preservim/nerdcommenter'

" Customization / Tweaks
Plug 'terryma/vim-smooth-scroll'
Plug 'Yggdroot/indentLine'

"=== Themes ===
Plug 'morhetz/gruvbox' 

call plug#end()

" ==================================================
"                  Configurations 
" ==================================================
set ai "Auto indent
set autoread
set backspace=eol,start,indent
set cmdheight=1
set completeopt=noinsert,menu,menuone,preview
set expandtab
set hid
set hlsearch
set ignorecase
set incsearch
set lbr
set magic
set nobackup
set noerrorbells
set noswapfile
set novisualbell
set nowb
set nowrap
set number
set ruler
set shiftwidth=4
set showcmd
set showmatch
set si "Smart indent
set smartcase
set smarttab
set smarttab
set so=7
set spr
set tabstop=4
set timeoutlen=250
set timeout ttimeoutlen=50
set tm=500
set t_vb=
set tw=500
set whichwrap+=<,>,h,l
set wildignore=*.o,*~,*.pyc
set wildmenu
set wrap "Wrap lines
set background=dark
colorscheme slate

if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif
" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Set to auto read when a file is changed from the outside
au FocusGained,BufEnter * silent! checktime

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

" Workaround to register escape char for alt key as alt key
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw

" ==================================================
"                    Key Binds
" ==================================================

" leader key
noremap <Space> <Nop>
map <Space> <Leader>

" Ctrl + S = save file
noremap <C-S> <Esc>:w<CR>
vnoremap <C-S> <Esc>:w<CR>
inoremap <C-S> <Esc>:w<CR>

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

noremap J <Nop> 
noremap H gT
noremap L gt

" move lines up and down
noremap <A-k> :move -2<CR>
noremap <A-j> :move +1<CR>
noremap <A-up> :move -2<CR>
noremap <A-down> :move +1<CR>

vnoremap <A-k> :move '<-2<CR>gv
vnoremap <A-j> :move '>+1<CR>gv
vnoremap <A-up> :move '<-2<CR>gv
vnoremap <A-down> :move '>+1<<CR>gv

" prevent ctrl z typo from crashing vim
noremap <C-z> <Nop>
inoremap <C-z> <Nop>

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 5, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 5, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 5, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 5, 4)<CR>

" ==================================================
"                  Plugin: WhichKey
" ==================================================

nnoremap <silent> <leader> :silent WhichKey ' '<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual ' '<CR>

let g:which_key_map =  {}
let g:which_key_sep = ': '

let g:which_key_use_floating_win = 1

" Single mappings
let g:which_key_map['/'] = [ '<Plug>NERDCommenterToggle'        , 'comment' ]
let g:which_key_map['f'] = [ ':Files'                           , 'search files' ]
let g:which_key_map['e'] = [ ':NERDTreeToggle'                      , 'file explorer (NERDTree)']
let g:which_key_map['r'] = [ ':RG'                              , 'ripgrep' ]
let g:which_key_map['t'] = [ ':term'                            , 'terminal']

"let g:which_key_map.b = {
    "\ 'name' : '+buffer'.
    "\ 'd'    : ':

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
