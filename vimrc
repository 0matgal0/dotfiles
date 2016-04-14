if !isdirectory(expand("~/.vim"))
  sil !wget github.com/junegunn/vim-plug/raw/master/plug.vim -P ~/.vim/autoload
  sil call system('mkdir -p ~/.vim/undodir')
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')                   | let g:plug_window = 'new'
Plug 'kien/ctrlp.vim'                      | let g:ctrlp_working_path_mode = ''
Plug 'mbbill/undotree'                        | let g:undotree_WindowLayout = 3
Plug 'ap/vim-css-color',             { 'for': ['html', 'xhtml', 'xml', 'css'] }
Plug 'chrisbra/nrrwrgn'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-vinegar'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-vividchalk'
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/syntastic'                  | let g:syntastic_enable_signs = 0
Plug 'gregsexton/matchtag',        { 'for': ['html', 'xhtml', 'xml', 'jinja'] }
Plug 'nanotech/jellybeans.vim'
Plug 'andrewradev/splitjoin.vim'
call plug#end()

set statusline=%<%f\ %y%{exists(':Git')&&&ft!='help'?fugitive#statusline():''}
set statusline+=%{exists(':SyntasticCheck')?SyntasticStatuslineFlag():''}
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}%r
set statusline+=%{&paste?'[paste]':''}%m%=\ %-15.(%l/%L,%c%V%)%P
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
set t_ti= t_te= t_Co=256
set smarttab shiftround
set ignorecase hlsearch
set previewheight=0
set noshowmode
set nobackup
set list

nn K :grep! <cword> %<cr><c-l>
nn Q :ls<CR>:b<space>
nn <silent> Q :ccl<CR>:call setqflist(map(filter(range(1, bufnr('$')),
      \ 'buflisted(v:val)'), '{"bufnr": v:val}'))<CR>:cope<CR>
      \ :setl ma<CR>:sil %s/\|\|.*//g<CR>:setl nomod noma<CR>
      \ :let w:quickfix_title = 'buffers'<CR>
nn <silent> <F1> :set cul! rnu! nu!<CR>
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

command! TrimWhitespace %s/\s\+$//
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
      \ | diffthis | wincmd p | diffthis
command! Scratch 5new Scratch | setl hid bt=nofile ft=markdown | exe 'norm G'

set guioptions=c guicursor=a:blinkon0 guifont=Monospace\ 12
command! -bar -nargs=0 Bigger
      \ :let &guifont = substitute(&guifont,'\d\+$','\=submatch(0)+1','')
command! -bar -nargs=0 Smaller
      \ :let &guifont = substitute(&guifont,'\d\+$','\=submatch(0)-1','')
noremap <M-,> :Smaller<CR>
noremap <M-.> :Bigger<CR>

set background=dark
" if g:colors_name=='default'
"   set background=light
"   hi TabLine      NONE
"   hi link TabLine TabLinefill
"   hi Normal       cterm=none ctermbg=White ctermfg=Black
"   hi Error        cterm=none ctermbg=Red   ctermfg=Black
"   hi StatusLine   cterm=none ctermfg=White ctermbg=Black
"   hi StatusLineNC cterm=none ctermfg=Grey  ctermbg=Black
"   hi LineNr       cterm=none ctermfg=Black ctermbg=LightGrey
"   " hi CursorLine   cterm=none ctermbg=193
"   hi Visual       cterm=none ctermbg=189
"   hi Type         cterm=none ctermfg=22
"   hi Identifier   cterm=none ctermfg=24
"   hi PreProc      cterm=none ctermfg=89

"   " Match git diff colors
"   hi diffFile     cterm=bold       gui=bold
"   hi diffLine     ctermfg=DarkCyan guifg=#00AAAA
"   hi diffAdded    ctermfg=Green    guifg=#55FF55
"   hi diffRemoved  ctermfg=Red      guifg=#FF5555
" endif
colorscheme jellybeans

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

function! Git()
  let hunk = sy#repo#get_stats()
  if hunk[0] >= 0 && &ft != 'help'
    return printf('[+%s ~%s -%s =>%s]', hunk[0], hunk[1], hunk[2],
          \ fugitive#head(7))
  endif
  return ''
endfunction
