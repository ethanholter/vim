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
Plug 'tpope/vim-sensible' 
Plug 'junegunn/vim-plug'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'liuchengxu/vim-which-key'
Plug 'voldikss/vim-floaterm'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

"=== Themes ===
Plug 'morhetz/gruvbox'

call plug#end()

" ==================================================
"                  Configurations 
" ==================================================

set number

" Workaround to register escape char for alt key as alt key
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw

set timeout ttimeoutlen=50

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Set color scheme
set background=dark
autocmd vimenter * ++nested colorscheme gruvbox

" ==================================================
"                    Key Binds
" ==================================================

" allows overriding of sensible following this line
runtime! plugin/sensible.vim

" leader key
nnoremap <Space> <Nop>
nmap <Space> <Leader>

" Ctrl + S = save file
noremap <C-S> <Nop>
inoremap <C-S> <Nop>
map <C-S> <Esc>:w<CR>
imap <C-S> <Esc>:w<CR>

" Ctrl + X = close buffer (quite) similar to nano
noremap <C-X> <Esc>:q<CR>
inoremap <C-X> <Esc>:q<CR>
tnoremap <C-X> <C-\><C-n>:FloatermKill<CR>

" move lines up and down
noremap <A-k> :move -2<CR>
noremap <A-j> :move +1<CR>
noremap <A-up> :move -2<CR>
noremap <A-down> :move +1<CR>

" hold shift to scroll faster 
nnoremap J 5j
nnoremap K 5k

" move left and right buffers
map L <C-w>w
map H <C-w>W

" move L R through tabs
noremap <A-h> gt
noremap <A-l> gT

" Curr dir in NERDTree
nnoremap . <Nop>
let NERDTreeMapChdir='.'
let NERDTreeMapChangeRoot='.'
" ==================================================
"                  Plugin: WhichKey
" ==================================================

nnoremap <silent> <leader> :silent WhichKey ' '<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual ','<CR>

let g:which_key_map =  {}
let g:which_key_sep = ': '

set timeoutlen=250

let g:which_key_use_floating_win = 1

" Single mappings
let g:which_key_map['/'] = [ '<Plug>NERDCommenterToggle'        , 'comment' ]
let g:which_key_map['f'] = [ ':Files'                           , 'search files' ]
let g:which_key_map['h'] = [ '<C-W>s'                           , 'split below']
let g:which_key_map['e'] = [':NERDTreeToggle'                         , 'file explorer (NERDTree)']
let g:which_key_map['L'] = [ ':SLoad'                           , 'load session']
let g:which_key_map['l'] = [ ':Limelight!!'                     , 'limelight']
let g:which_key_map['z'] = [ ':Goyo'                            , 'zen mode']
let g:which_key_map['r'] = [ ':RG'                              , 'ripgrep' ]
let g:which_key_map['g'] = [ ':FloatermNew lazygit'             , 'git']
let g:which_key_map['d'] = [ ':FloatermNew lazydocker'          , 'docker']
let g:which_key_map['k'] = [ ':FloatermNew k9s'                 , 'k9s']
let g:which_key_map['t'] = [ ':FloatermNew'                     , 'terminal']

let g:which_key_map['v'] = [ '<C-W>v'                           , 'split right']

let g:which_key_map.f = {
      \ 'name' : '+find',
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
