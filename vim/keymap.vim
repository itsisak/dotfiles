" Keybindings for vim

inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
" prev does not work
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>" 
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
nnoremap <C-c>      :VimtexCompile  <CR>
" nnoremap <C-n>      :NERDTreeFocus  <CR>
nnoremap <C-t>      :NERDTreeToggle <CR>
nnoremap <C-f>      :NERDTreeFind   <CR>
nnoremap <C-b>      :nohl           <CR>
nnoremap <C-w>      :set wrap!       <CR>
nnoremap <space>    :
nnoremap T      :vert terminal <CR>
" nnoremap <>      :vert terminal <CR> 
nnoremap J          15jzz
nnoremap K          15kzz
vnoremap J          15jzz
vnoremap K          15kzz
nnoremap H          :vert bo help           <C-r><C-w><CR>
nmap <silent> <c-k> :wincmd k <CR>
nmap <silent> <c-j> :wincmd j <CR>
nmap <silent> <c-h> :wincmd h <CR>
nmap <silent> <c-l> :wincmd l <CR>
nmap <silent> <c-n> gt
nmap <silent> <c-p> gT

" search and replace all:
" :%s/<search>/<replace>/g
" Search and replace one by one
" something cgn n .
