"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype on                                 " Enable type file detection. Vim will be able to try to detect the type of file is use.
filetype plugin on                          " Enable plugins and load plugin for the detected file type.
filetype indent on                          " Load an indent file for the detected file type.

syntax on                                   " Turn syntax highlighting on.

set nocompatible                            " Disable compatibility with vi which can cause unexpected issues.
set noesckeys                               " No arrow keys in insert (caused delay for <shift+O> after <esc>).
set number relativenumber                   " Add numbers to the file.
set cursorline                              " Highlight cursor line underneath the cursor horizontally.
set shiftwidth=4                            " Set shift width to 4 spaces.
set tabstop=4                               " Set tab width to 4 columns.
set expandtab                               " Use space characters instead of tabs.
set nobackup                                " Do not save backup files.
set scrolloff=10                            " Do not let cursor scroll below or above N number of lines when scrolling.
set nowrap                                  " Do not wrap lines. Allow long lines to extend as far as the line goes.
set linebreak                               " Break long lines.
set incsearch                               " While searching though a file incrementally highlight matching characters as you type.
set smartcase                               " Search with capital letters (overrides ignorecase).
set showcmd                                 " Show partial command you type in the last line of the screen.
set showmatch                               " Show matching words during a search.
set noshowmode                              " Do not show current mode in command line (opposite of showmode).
set shortmess+=F                            " Do not echo file name to commandline.
set hlsearch                                " Use highlighting when doing a search.
set history=1000                            " Set the commands to save in history default number is 20.
set wildmenu                                " Enable auto completion menu after pressing TAB.
set wildmode=list:longest                   " Make wildmenu behave like similar to Bash completion.
set wildignore=                             " Ignore files, do not open in vim.
    \ *.docx,
    \ *.jpg,
    \ *.png,
    \ *.gif,
    \ *.pdf,
    \ *.pyc,
    \ *.exe,
    \ *.flv,
    \ *.img,
    \ *.xlsx
set exrc                                    " Search projects for local .vimrc files.
set secure                                  " Prevent 'autocmd', shell and write commands in local .vimrc files.

if has('termguicolors')
 set termguicolors                          " Better colors (required for current colorscheme)
endif

" Plugins

call plug#begin('~/.vim/plugged')           " Plugin manager
    " Plug 'sainnhe/sonokai'                  " Colorscheme
    Plug 'haishanh/night-owl.vim'           " Colorscheme
    Plug 'preservim/nerdtree'               " File manager
    Plug 'itchyny/vim-gitbranch'            " Get current git branch in vim
    Plug 'pangloss/vim-javascript'          " JavaScript support
    Plug 'leafgarland/typescript-vim'       " TypeScript syntax
    Plug 'maxmellon/vim-jsx-pretty'         " JS and JSX syntax
    Plug 'neoclide/coc.nvim', { 'branch': 'master', 'do': 'npm ci' }
    Plug 'lervag/vimtex'                    " LaTeX compilation
    Plug '/opt/homebrew/opt/fzf'            " Fuzzyfinder in vim
call plug#end()

let NERDTreeShowHidden                      = 1
let g:coc_global_extensions                 = ['coc-tsserver']
let g:vimtex_view_method                    = "skim"
let g:vimtex_compiler_latexmk               = { 'out_dir' : 'build' }
" let g:sonokai_style                         = 'andromeda'
" let g:sonokai_better_performance            = 1
" let g:sonokai_disable_italic_comment        = 1

" colorscheme sonokai
colorscheme night-owl

source $HOME/.vim/keymap.vim                " Load custom keybindings
source $HOME/.vim/statusline.vim            " Load custom statusline
