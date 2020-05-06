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
    noremap <leader>f :Goyo<Enter>

" Automatically deletes all trailing whitespace on save
    autocmd BufWritePre * %s/\s\+$//e
    autocmd FileType ruby,python autocmd BufWritePre <buffer> :%s/\($\n\s*\)\+\%$//e

" Netrw configuration
    autocmd FileType netrw nnoremap ? :help netrw-quickmap<Enter>
    noremap <leader>x <Esc>:e .<Enter>
    let g:netrw_winsize = 25

" Buffer navigation
    noremap <leader>h <Esc>:bp<Enter>
    noremap <leader>l <Esc>:bn<Enter>

" Turn on spellchecking
    noremap <leader>L <Esc>:set spell spelllang=en_us<Enter>

" Git commands
    noremap <leader>s <Esc>:!git status<Enter>
    noremap <leader>r <Esc>:!git reset HEAD %<Enter>
    noremap <leader>R <Esc>:!git restore %<Enter>
    noremap <leader>d <Esc>:!git diff %<Enter>
    noremap <leader>c <Esc>:!git diff --cached %<Enter>
    noremap <leader>a <Esc>:!git add %<Enter>
    noremap <leader>u <Esc>:!git add -u<Enter>

" Comment
    noremap <leader>/ I// <Esc>

    noremap <leader>g <Esc>:GitGutterToggle<Enter>
    noremap <leader>e <Esc>:s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g<Enter>

    noremap <leader>b <Esc>:make<Enter>
    noremap <leader># <Esc>:!shellcheck %<Enter>


