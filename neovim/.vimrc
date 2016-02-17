" ##### Plugin Initialization #####

call plug#begin('~/.vim/plugged')
Plug 'easymotion/vim-easymotion'
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdTree'
Plug 'tpope/vim-fugitive'
Plug 'reedes/vim-pencil'
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'
"Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/vimproc.vim'
Plug 'benekastah/neomake'
Plug 'neovimhaskell/haskell-vim'
"Plug 'zchee/deoplete-jedi'
Plug 'Valloric/YouCompleteMe'
call plug#end()

" ##### General Settings #####

" enable syntax highlighting
syntax on

colorscheme solarized

set background=dark

" highlight the current line
set cursorline

" remove signcolmn bg
hi! SignColumn ctermbg=None

" make tildes blank
hi! EndOfBuffer ctermbg=bg ctermfg=bg guibg=bg guifg=bg

set encoding=utf-8

" make indents spaces rather than tabs in python etc.
filetype indent plugin on

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
filetype plugin indent on

" don't leave search matches highlighted
set nohlsearch

" ##### Custom Keymappings #####

"; also functions as :
nmap ; :

let mapleader = " "

" easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" resize current buffer by +/- 5
nnoremap <D-left> :vertical resize -5<cr>
nnoremap <D-down> :resize +5<cr>
nnoremap <D-up> :resize -5<cr>
nnoremap <D-right> :vertical resize +5<cr>

"function to move to previous error as defined in locations
function! <SID>LocationPrevious()
  try
    lprev
  catch /^Vim\%((\a\+)\)\=:E553/
    llast
  endtry
endfunction

"function to move to next error as defined in locations
function! <SID>LocationNext()
  try
    lnext
  catch /^Vim\%((\a\+)\)\=:E553/
    lfirst
  endtry
endfunction

"keybindings for error jumping functions
nnoremap <silent> <Plug>LocationPrevious    :<C-u>exe 'call <SID>LocationPrevious()'<CR>
nnoremap <silent> <Plug>LocationNext        :<C-u>exe 'call <SID>LocationNext()'<CR>
"nmap <silent> ,,    <Plug>LocationPrevious
"nmap <silent> ..    <Plug>LocationNext

" ##### Language Specific Settings #####

" For Neovim, specify which python to use
let g:python_host_prog = '/bin/python2.7'

autocmd Filetype haskell setlocal tabstop=2 shiftwidth=2 softtabstop=2

" ##### Airline #####

" airline stuff
let g:airline_powerline_fonts = 1
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols = {}
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'
let g:airline_theme = 'base16'
let g:airline#extensions#branch#enabled = 1

" always show airline
set laststatus=2

" ##### YouCompleteMe #####

" automatically confirm use of ycm conf
let g:ycm_confirm_extra_conf = 0

" make ycm use location list for errors
let g:ycm_always_populate_location_list = 1

let g:ycm_semantic_triggers = {'haskell' : ['.']}

"automatically close the complete buffer split thing
autocmd CompleteDone * pclose

" ##### EasyMotion #####

" press s to move to location by searching for two letters
map s <Plug>(easymotion-s2)
" press super key plus a movement key to activate the easymotion version
map <Leader> <Plug>(easymotion-prefix)

map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

" ##### neco-ghc #####
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

" ##### deoplete #####

let g:deoplete#enable_at_startup = 1

inoremap <silent><expr> <Tab>
    \ pumvisible() ? "\<C-n>" :
    \ deoplete#mappings#manual_complete()

" ##### ghc-mod

map <silent> tw :GhcModTypeInsert<CR>
map <silent> ts :GhcModSplitFunCase<CR>
map <silent> tq :GhcModType<CR>
map <silent> te :GhcModTypeClear<CR>

" ##### neomake #####

" run neomake on every write
autocmd! BufWritePost * Neomake
