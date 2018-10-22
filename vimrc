" Bootstrap vim-plug
if !isdirectory(expand("~/.vim"))
  sil !wget github.com/junegunn/vim-plug/raw/master/plug.vim -P ~/.vim/autoload
  sil call system('mkdir -p ~/.vim/undodir')
  autocmd VimEnter * PlugInstall
endif

" Sensible settings
filetype plugin indent on
syntax enable

set ai bs=indent,eol,start cpt-=i sta nf-=octal ttimeout ttimeoutlen=100
set incsearch
set laststatus=2
set ruler
set wildmenu
set scrolloff=1
set sidescrolloff=5
set display+=lastline
set encoding=utf-8
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set formatoptions+=j

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif
set shell=/bin/bash
set autoread
  set history=1000
  set tabpagemax=50
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options
runtime! macros/matchit.vim

" Load plugins
call plug#begin('~/.vim/plugged')                  | let g:plug_window = 'vnew'
Plug 'kien/ctrlp.vim'                      | let g:ctrlp_working_path_mode = ''
Plug 'w0ng/vim-hybrid'
Plug 'mbbill/undotree'                        | let g:undotree_WindowLayout = 1
Plug 'junegunn/gv.vim'
Plug 'ap/vim-css-color',             { 'for': ['html', 'xhtml', 'xml', 'css'] }
Plug 'chrisbra/nrrwrgn'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
" Plug 'itchyny/lightline.vim'
" Plug 'https://github.com/vim-airline/vim-airline'
"   let g:airline_powerline_fonts = 1
"   if !exists('g:airline_symbols')
"     let g:airline_symbols = {}
"   endif
"   let g:airline_left_sep = ''
"   let g:airline_left_alt_sep = ''
"   let g:airline_right_sep = ''
"   let g:airline_right_alt_sep = ''
"   let g:airline_symbols.branch = ''
"   let g:airline_symbols.readonly = ''
"   let g:airline_symbols.linenr = '☰'
"   let g:airline_symbols.maxlinenr = ''
Plug 'tpope/vim-vinegar'
" Plug 'ryanoasis/vim-devicons'
" Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-emoji'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-surround'
" Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
" Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-vividchalk'
Plug 'tpope/vim-commentary'
" Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/syntastic'                  | let g:syntastic_enable_signs = 0
Plug 'gregsexton/matchtag',        { 'for': ['html', 'xhtml', 'xml', 'jinja'] }
" Plug 'nanotech/jellybeans.vim'
Plug 'andrewradev/splitjoin.vim'
Plug 'jszakmeister/vim-togglecursor'
Plug 'drewtempelmeyer/palenight.vim'       | let g:palenight_terminal_italics=1
Plug 'nelstrom/vim-mac-classic-theme'
call plug#end()

" Settings
set statusline=%<%f\ %y%{exists(':Git')&&&ft!='help'?Git():''}
set statusline+=%{exists(':SyntasticCheck')?SyntasticStatuslineFlag():''}
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}%r
set statusline+=%{&paste?'[paste]':''}%m%=\%-15.(%l/%L,%c%V%)\ %P
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*
set cfu=syntaxcomplete#Complete ofu=syntaxcomplete#Complete
set complete=.,b,u,t completeopt=noselect,menuone,preview
set grepprg=grep\ -IHinr\ --exclude-dir=\"\.*\\"
set wildmode=longest,list wildignorecase
set undofile undodir=$HOME/.vim/undodir/
set nofoldenable foldmethod=indent
set viminfo+=n~/.vim/viminfo
set breakindent showbreak=..
set clipboard=unnamedplus
set smarttab shiftround
set ignorecase hlsearch
set t_ti= t_te= t_ut=
" set nu numberwidth=6
set previewheight=0
" set signcolumn=yes
set termguicolors
set cursorline
set noshowmode
" set cmdheight=2
set nobackup
set list

" Mappings & Abbrevs
nn <silent> <C-L> :noh<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
nn K :grep! <cword> %<cr><c-l>
nn Q :ls<CR>:b<space>
nn <silent> Q :ccl<CR>:call setqflist(map(filter(range(1, bufnr('$')),
      \ 'buflisted(v:val)'), '{"bufnr": v:val}'))<CR>:cope<CR>
      \ :setl ma<CR>:sil %s/\|\|.*//g<CR>:setl nomod noma<CR>
      \ :let w:quickfix_title = 'buffers'<CR>
nn <silent> <F1> :set cul! rnu! nu!<CR>
ino <C-U> <C-G>u<C-U>
ino <F1> <nop>
nn val v$h
nn vil ^vg_
nn q: :q
nn @@ @q
nn Y y$
ca E e
ca Q q
ca Qa qa
ca Wq wq

" Commands
command! TrimWhitespace %s/\s\+$//
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
      \ | diffthis | wincmd p | diffthis
command! Scratch 5new Scratch | setl hid bt=nofile ft=markdown | exe 'norm G'

" function! SwitchBackground()
"   if &background == 'light'
"     colo jellybeans
"   else
"     colo mac_classic
"   endif
" endfunction
" command! SwitchBackground :call SwitchBackground()

augroup AutoCmds
  au!
  autocmd BufWritePost        $MYVIMRC source %
  autocmd BufReadPost         *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" | endif
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost    l* nested lwindow
  autocmd FileType           qf setl nowrap linebreak
  autocmd InsertEnter         * set splitbelow
  autocmd InsertLeave         * set nosplitbelow
augroup END

" Additional functions
function! Git()
  let hunk = sy#repo#get_stats()
  "return printf('[+%s ~%s -%s =>%s]', hunk[0], hunk[1], hunk[2],
  if hunk[0] >= 0 && &ft != 'help'
    return printf('[+%s ~%s -%s *%s]', hunk[0], hunk[1], hunk[2],
          \ fugitive#head(7))
  endif
  return ''
endfunction

" Colorscheme
colo default
hi TabLine      NONE
hi TabLineFill  NONE
hi link TabLine TabLinefill
hi link TabLineFill StatusLine
hi Normal       guifg=#000000 guibg=#ffffff gui=none
hi NonText      guifg=#969696 guibg=#ffffff gui=none
hi LineNr       guifg=#969696 guibg=#f2f2f2 gui=none
hi SignColumn   guifg=NONE    guibg=#f2f2f2 gui=none
hi CursorLine   guifg=NONE    guibg=#f0f8ff gui=none cterm=none
hi CursorLineNR guifg=#2e9dff guibg=#f0f8ff gui=bold
hi Comment      guifg=#cf3125 guibg=NONE    gui=none
hi Todo         guifg=#008311 guibg=NONE    gui=bold
hi String       guifg=#008311 guibg=NONE    gui=none
hi Special      guifg=#cf3125 guibg=NONE    gui=none
hi Type         guifg=#6f41a7 guibg=NONE    gui=none
hi Statement    guifg=#b833a2 guibg=NONE    gui=none
hi Keyword      guifg=#b833a2 guibg=NONE    gui=none
hi Structure    guifg=#b833a2 guibg=NONE    gui=none
hi StorageClass guifg=#b833a2 guibg=NONE    gui=none
hi Boolean      guifg=#b833a2 guibg=NONE    gui=none
hi Null         guifg=#b833a2 guibg=NONE    gui=none
hi Function     guifg=#008b8b guibg=NONE    gui=none
hi Identifier   guifg=#008b8b guibg=NONE    gui=none
hi Constant     guifg=#77492d guibg=NONE    gui=none
hi PreProc      guifg=#77492d guibg=NONE    gui=none
hi Number       guifg=#2934d4 guibg=NONE    gui=none
hi Character    guifg=#2934d4 guibg=NONE    gui=none
hi SpecialChar  guifg=#2934d4 guibg=NONE    gui=none
hi StatusLine   guifg=#ffffff guibg=#646464 gui=none cterm=none
hi StatusLineNC guifg=#969696 guibg=#f2f2f2 gui=none
hi VertSplit    guifg=#969696 guibg=#f2f2f2 gui=none
hi Pmenu        guifg=#000000 guibg=#d7bdff gui=none
hi PmenuSel     guifg=#ffffff guibg=#7a25fa gui=none
hi Error        guifg=#ff0000 guibg=NONE    gui=bold

" Gui settings
if has("gui_running")
  set guifont=Monospace\ 12
  set guioptions=ck guicursor=a:blinkon0
  command! -bar -nargs=0 Bigger
        \ :let &guifont = substitute(&guifont,'\d\+$','\=submatch(0)+1','')
  command! -bar -nargs=0 Smaller
        \ :let &guifont = substitute(&guifont,'\d\+$','\=submatch(0)-1','')
  noremap <M-,> :Smaller<CR>
  noremap <M-.> :Bigger<CR>
endif
