let mapleader =" "

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'Valloric/YouCompleteMe', {'do': 'python3 install.py --clang-completer'}
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/vim-emoji'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'dracula/vim', {'as': 'dracula'}
Plug 'tikhomirov/vim-glsl'
call plug#end()

" Some basics:
    set bg=dark
    set clipboard=unnamedplus
    set nocompatible
    filetype plugin on
    syntax on
    set encoding=utf-8
    set number relativenumber
    set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
    let g:gitgutter_map_keys = 0
    let g:ycm_open_loclist_ycm_diags = 0
    command! W write
    command! Bd bd
    autocmd FileType markdown,tex set spell spelllang=en_us

" Choose theme
    " color dracula
    color cyber


" Enable autocompletion:
    set wildmode=longest,list,full

" Disables automatic commenting on newline:
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Disable Ex mode
    nnoremap Q @q

" Disable scratch buffer
    set completeopt-=preview

" Splits open at the bottom and right
    set splitbelow splitright

" Gitgutter Emoji
if emoji#available()
    let g:gitgutter_sign_added = emoji#for('green_heart')
    let g:gitgutter_sign_modified = emoji#for('blue_heart')
    let g:gitgutter_sign_removed = emoji#for('heart_decoration')
    let g:gitgutter_sign_modified_removed = emoji#for('purple_heart')

    let g:ycm_error_symbol = emoji#for('collision')
    let g:ycm_warning_symbol = emoji#for('koko')
endif

" Focus button for focused writing
    nnoremap <leader>f :Goyo<Enter>

" Automatically deletes all trailing whitespace on save
    autocmd BufWritePre * %s/\s\+$//e
    autocmd FileType ruby,python autocmd BufWritePre <buffer> :%s/\($\n\s*\)\+\%$//e

" Netrw configuration
    autocmd FileType netrw nnoremap ? :help netrw-quickmap<Enter>
    nnoremap <leader>x :e %:h<Enter>
    let g:netrw_winsize = 25

" Buffer navigation
    nnoremap <leader>h :bp<Enter>
    nnoremap <leader>l :bn<Enter>

" Faster scrolling
    nnoremap <C-e> 4<C-e>
    nnoremap <C-y> 4<C-y>

" Keep selection
    vnoremap < <gv
    vnoremap > >gv

" Save
    nnoremap <leader><leader> :w<Enter>

" Escape alias
    inoremap jk <Esc>

" Turn on spellchecking
    nnoremap <leader>L :set spell spelllang=en_us<Enter>

" Launch fuzzy finder
    nnoremap <leader>z :FZF<Enter>

" Git commands
    nnoremap <leader>s :!git status<Enter>
    nnoremap <leader>r :!git restore --staged %<Enter>
    nnoremap <leader>R :!git restore %<Enter>
    nnoremap <leader>d :!git diff %<Enter>
    nnoremap <leader>c :!git diff --cached %<Enter>
    nnoremap <leader>a :!git add %<Enter>
    nnoremap <leader>u :!git add -u<Enter>

" Comment
    noremap <leader>/ I// <Esc>

" Use extended regex
    nnoremap / /\v
    vnoremap / /\v

    nnoremap <leader>g :GitGutterToggle<Enter>
    noremap <leader>e :s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g<Enter>:let @/ = ""<Enter>

    nnoremap <leader>b :make<Enter>
    nnoremap <leader>B :w<Enter>:make<space>run<Enter> %Linux%
    nnoremap <leader># :!shellcheck %<Enter>


