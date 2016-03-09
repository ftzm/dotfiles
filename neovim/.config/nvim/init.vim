" ##### Plugin Initialization #####

call plug#begin('~/.vim/plugged')
"Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdTree'
Plug 'tpope/vim-fugitive'
Plug 'reedes/vim-pencil'
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'
Plug 'bitc/vim-hdevtools'
Plug 'Shougo/vimproc.vim'
Plug 'benekastah/neomake'
Plug 'neovimhaskell/haskell-vim'
Plug 'Valloric/YouCompleteMe'
Plug 'wikitopian/hardmode'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
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
" personal solarized adjustments
" vertical split is a thin bg highlight color
hi! VertSplit ctermbg=bg ctermfg=0 guibg=bg
" little status line bit between airlines matches split color
hi! StatusLine ctermbg=4 ctermfg=0 guibg=bg guifg=None
hi! StatusLineNC ctermbg=bg ctermfg=0 guibg=bg guifg=None

set encoding=utf-8
set fenc=utf-8


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

"leader mapping
let mapleader = " "

"; also functions as :
"nmap ; :

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

map <Leader>n :NERDTreeToggle<cr>

"function to move to previous error as defined in locations
function! <SID>LocationPrevious()
  try
    lprev
  catch /^Vim\%((\a\+)\)\=:E553/
    llast
  catch /^Vim\%((\a\+)\)\=:E42/
    echo "Location list empty"
  catch /^Vim\%((\a\+)\)\=:E776/
    echo "Write first to check for errors"
  endtry
endfunction

"function to move to next error as defined in locations
function! <SID>LocationNext()
  try
    lnext
  catch /^Vim\%((\a\+)\)\=:E553/
    lfirst
  catch /^Vim\%((\a\+)\)\=:E42/
    echo "Location list empty"
  catch /^Vim\%((\a\+)\)\=:E776/
    echo "Write first to check for errors"
  endtry
endfunction

"keybindings for error jumping functions
nnoremap <silent> <Plug>LocationPrevious    :<C-u>exe 'call <SID>LocationPrevious()'<CR>
nnoremap <silent> <Plug>LocationNext        :<C-u>exe 'call <SID>LocationNext()'<CR>
map <Leader>k    <Plug>LocationPrevious
map <Leader>j    <Plug>LocationNext

"write remap
map <Leader>w   :w<cr>

"remove trailing whitespaces before all writes
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Hack (or trick) to save a file using sudo after it's been opened
cmap w!! w ! sudo tee > /dev/null %

" ##### Language Specific Settings #####


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
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_min_count = 2

"don't know what this is, but disabling gets rid of the yellow chunk right of
"the status line when a file has been modified
let g:airline_detect_modified=0

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

let g:ycm_python_binary_path = '/usr/bin/python3'

" ##### EasyMotion #####

" press s to move to location by searching for two letters
"map s <Plug>(easymotion-s2)
" press super key plus a movement key to activate the easymotion version
"map <Leader> <Plug>(easymotion-prefix)
"
"map <Leader>l <Plug>(easymotion-lineforward)
"map <Leader>j <Plug>(easymotion-j)
"map <Leader>k <Plug>(easymotion-k)
"map <Leader>h <Plug>(easymotion-linebackward)
"
"let g:Easymotion_smartcase=1

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

let g:neomake_haskell_hdevtools_exe = '/home/matt/bin/hdevtools-stack'
let g:neomake_haskell_ghcmod_exe = '/home/matt/bin/ghc-mod-stack'
let g:neomake_haskell_enabled_makers = ['hdevtools']
" ##### sneak #####

" easymotion style
let g:sneak#streak = 1

" ##### hardmode #####
autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
nnoremap <leader>h <Esc>:call ToggleHardMode()<CR>

" ##### UltiSnips #####

" pressing enter expands a snippet
let g:UltiSnipsExpandTrigger = "<nop>"
let g:ulti_expand_or_jump_res = 0
function ExpandSnippetOrCarriageReturn()
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return snippet
    else
        return "\<CR>"
    endif
endfunction
inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"

