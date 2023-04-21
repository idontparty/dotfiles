" Vim config
"
" Set terminal gui colors.
set termguicolors

" Set line number
set number

" Set syntax
syntax on

" Use shared clipboard
set clipboard+=unnamedplus

" Copy with mouse to shared clipboard
set mouse=r

" Set up vim-plug
call plug#begin()
  " NERDTree - side bar for file exploration
  Plug 'preservim/nerdtree'
  " Semshi - semantic highlighting for Python
  Plug 'numirias/semshi'
  
call plug#end()


" Update shortcuts for NERDTree
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

