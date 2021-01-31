"       ___           ___       ___           ___           ___   
"      /\  \         /\__\     /\  \         /\__\         /\  \  
"     /::\  \       /:/  /    /::\  \       /::|  |        \:\  \ 
"    /:/\:\  \     /:/  /    /:/\:\  \     /:|:|  |        /::\__\
"   /::\~\:\  \   /:/  /    /::\~\:\  \   /:/|:|__|__   __/:/\/__/
"  /:/\:\ \:\__\ /:/__/    /:/\:\ \:\__\ /:/ |::::\__\ /\/:/  /   
"  \/__\:\/:/  / \:\  \    \:\~\:\ \/__/ \/__/~~/:/  / \::/__/    
"       \::/  /   \:\  \    \:\ \:\__\         /:/  /   \:\__\    
"       /:/  /     \:\  \    \:\ \/__/        /:/  /     \/__/
"      /:/  /       \:\__\    \:\__\         /:/  /   
"      \/__/         \/__/     \/__/         \/__/    

" Basics
set number
set nowrap
set noshowmode
set incsearch
syntax on
filetype plugin on
set undofile
set undodir=~/.vim/undo/
set tabstop=4 shiftwidth=4
set autoindent
set mouse=a
set laststatus=2
set wildmode=longest,list,full
set wildmenu

" Auto install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'dense-analysis/ale'
Plug 'alemigliardi/vim-combo'
call plug#end()

let g:ale_set_balloons = 1
let g:ale_set_highlights = 0

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

" needed for consistent colors in tmux
set background=dark 

" Search ctags file
set tags=./tags;$HOME
" Search cscope file
function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  " else add the database pointed to by environment variable 
  elseif $CSCOPE_DB != "" 
    cs add $CSCOPE_DB
  endif
endfunction
au BufEnter /* call LoadCscope()

" Put a dark background behind numbers
" highlight LineNr ctermbg=234

let maplocalleader = "/"

nnoremap <F10> :set hls!<CR>
nnoremap <F9> :set wrap!<CR>
nnoremap <F8> :set relativenumber!<CR>
nnoremap <F7> :Hexmode<CR>
nnoremap <F5> :o<CR>
nnoremap <C-S> :silent !pipes.sh -p 2<CR>:redraw!<CR>

nnoremap <S-Up> <C-u>
nnoremap <S-Down> <C-d>
inoremap <S-Up> <C-o><C-u>
inoremap <S-Down> <C-o><C-d>

" Change cursor
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Used to avoid triggering autocompletion
" inoremap <localleader><Tab> <Tab>

" Automatically deletes all trailing whitespace on save.
" autocmd BufWritePre * %s/\s\+$//e

set statusline=
" set statusline+=%#Folded#
" set statusline+=%{g:branchname}
set statusline+=%#DiffAdd#
set statusline+=\ %m\ 
set statusline+=%{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]\ 
set statusline+=%y\ 
set statusline+=%#WildMenu#
set statusline+=\ %f\ 
set statusline+=%#ColorColumn#
set statusline+=\ 
set statusline+=%{g:combo}\ 
set statusline+=%#ModeMsg#
set statusline+=%=

set statusline+=%#Folded#
set statusline+=\ %{LinterStatus()}\ 

set statusline+=%#DiffAdd#
set statusline+=\ %p%%
set statusline+=\ %l:%c\ 
set statusline+=%#StatusLineTerm#
set statusline+=\ 
set statusline+=%{mode()}\ 


""" HEX EDITOR
" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    silent :e " this will reload the file without trickeries 
              "(DOS line endings will be shown entirely )
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction
