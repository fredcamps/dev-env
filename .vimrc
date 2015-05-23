" My Default Settings
syntax enable
set nocp
set encoding=utf-8
set smarttab
set expandtab
set shiftwidth=4
set softtabstop=4
set backspace=indent,eol,start
set autoindent
set sm
set showmode
set ruler
set title
set nu
set ttyfast
set cursorline
set nowrap
set ls=2
set hlsearch
set incsearch
set tabpagemax=15
set preserveindent
set modeline
set tabstop=8
set background=dark
set t_Co=256
filetype indent on

colorscheme wombat256mod

map <C-l> :set list listchars=tab:¬\ ,trail:·,extends:>,precedes:< <CR>


" 99 characters line
let &colorcolumn=join(range(99,999),",")
hi ColorColumn ctermfg=darkgrey ctermbg=black guifg=darkgrey guibg=black


if has('vim_starting')
    " Required:
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" To install vim +NeoBundleInstall +qall
NeoBundle 'vim-scripts/ctags.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'vim-scripts/po.vim'
NeoBundle 'StanAngeloff/php.vim'
NeoBundle 'hdima/python-syntax'
NeoBundle 'joonty/vim-phpqa.git'
NeoBundle 'nvie/vim-flake8'
NeoBundle 'vim-scripts/Git-Branch-Info'

call neobundle#end()

" If there are uninstalled bundles found on startup,
"  " this will conveniently prompt you to install them.
NeoBundleCheck

" Required for NeoBundle
filetype plugin indent on

" My Elegant Status Bar
hi statusline ctermfg=darkgrey ctermbg=black guifg=darkgrey guibg=black
set statusline=%f                                       " Path to the file
set statusline+=\ -\                                    " Separator
set statusline+=\ %Y%y                                  " Type of the file
set statusline+=\ LANG:%{&spelllang}                    " Language
set statusline+=\ column:%c                             " Current Column
set statusline+=\ lines:%l/%L                           " Current line
set statusline+=\ %{''.(&fenc!=''?&fenc:&enc).''}       " Encoding
set statusline+=\ %{&ff}\                               " Format of the file

set statusline+=[
set statusline+=\ %{&wrap?'wrap':'nowrap'}
set statusline+=\ %{&hlsearch?'hlsearch':''}
set statusline+=\ %{&paste?'paste':''}
set statusline+=]
set statusline+=\ %r                                    " read only flag '[RO]'
set statusline+=\ %2*%m%*                               " modified flag '[+]' if modifiable
set statusline+=\ %h                                    " help flag '[Help]'
set statusline+=\ %{GitBranchInfoString()}
set statusline+=\ %{strftime(\"%Y-%m-%d\ %H:%M\")}


let g:git_branch_status_nogit=""

" NerdTree
let g:NERDTreeWinPos = "left"
imap <F12> <ESC> :NERDTreeToggle <CR> i
map <F12> :NERDTreeToggle <CR>
vmap <F12> <ESC> :NERDTreeToggle <CR> v

" PHPQA (PHPCS, LINT, MD...)
" let g:phpqa_messdetector_ruleset = "/path/to/phpmd.xml"
" let g:phpqa_codesniffer_args = "--standard=PSR-2"

" let g:phpqa_php_cmd='/path/to/php'
" let g:phpqa_codesniffer_cmd='/path/to/phpcs'
" let g:phpqa_messdetector_cmd='/path/to/phpmd'
" let g:phpqa_codesniffer_autorun = 0
" let g:phpqa_messdetector_autorun = 0
" let g:phpqa_codecoverage_autorun = 1

" Stop the location list opening automatically
" let g:phpqa_open_loc = 0
" let g:phpqa_codecoverage_file = "/path/to/clover.xml"
" Show markers for lines that ARE covered by tests (default = 1)
" let g:phpqa_codecoverage_showcovered = 0


" Python flake8
" call flake8#Flake8UnplaceMarkers()
autocmd FileType python map <buffer> <F3> :call Flake8()<CR>

let g:flake8_show_in_gutter=1
highlight link Flake8_Error      Error
highlight link Flake8_Warning    WarningMsg
highlight link Flake8_Complexity WarningMsg
highlight link Flake8_Naming     WarningMsg
highlight link Flake8_PyFlake    WarningMsg

"Required for python-vim
let python_highlight_all = 1

"Required for php-vim
function! PhpSyntaxOverride()
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END



