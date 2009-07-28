" Hissu {{{1
" Windowsでも.vimを読み込むようにする
set runtimepath& runtimepath+=$HOME/.vim
set nocompatible
filetype plugin indent on

if has('syntax')
	syntax enable
	set t_Co=256
	if !exists("g:colors_name")
		colorscheme desert256
	endif
endif

" 文字コード設定 {{{1
if &encoding !=# 'utf-8'
	set encoding=japan
endif

if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'

	" Does iconv support JIS X 0213 ?
	if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213,euc-jp'
		let s:enc_jis = 'iso-2022-jp-3'
	endif

	" Make fileencodings
	let &fileencodings = 'ucs-bom'
	if &encoding !=# 'utf-8'
		let &fileencodings = &fileencodings . ',' . 'ucs-2le'
		let &fileencodings = &fileencodings . ',' . 'ucs-2'
	endif
	let &fileencodings = &fileencodings . ',' . s:enc_jis

	if &encoding ==# 'utf-8'
		let &fileencodings = &fileencodings . ',' . s:enc_euc
		let &fileencodings = &fileencodings . ',' . 'cp932'
	elseif &encoding =~# '^euc-\%(jp\|jisx0213\)$'
		let &encoding = s:enc_euc
		let &fileencodings = &fileencodings . ',' . 'utf-8'
		let &fileencodings = &fileencodings . ',' . 'cp932'
	else  " cp932
		let &fileencodings = &fileencodings . ',' . 'utf-8'
		let &fileencodings = &fileencodings . ',' . s:enc_euc
	endif
	let &fileencodings = &fileencodings . ',' . &encoding

	unlet s:enc_euc
	unlet s:enc_jis
endif "



" Option: オプション設定 ========================================= {{{1
set ambiwidth=double
set autoindent
"set autowrite
set backspace=indent,eol,start
set backup
set backupcopy&
set backupdir=~/.vim/backup/
set backupskip&
set cinoptions=:0,(0,W1s
set directory=~/.vim/swap/
set formatoptions=tcroqnlM1
set history=100
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<
set mouse=
set nrformats="hex"
set ruler
set shiftwidth=2
set showcmd
set showmode
set showtabline=2
set smartcase
set softtabstop=2
set splitbelow
set splitright
set updatetime=3000
set tabstop=2
set title
set visualbell t_vb=
set wildmenu
set wildmode=list:longest

let &statusline = ''
let &statusline .= '%<%f %y%m%r'
let &statusline .= '%='
let &statusline .= '[%{&l:fileencoding == "" ? &encoding : &l:fileencoding}:%{&ff}]'
let &statusline .= '  %-14.(%l,%c%V%) %P'

let mapleader = ","
let maplocalleader = "."

if has("autochdir")
	set autochdir
else
	au BufEnter * execute "lcd " expand("%:p:h")
endif


" command {{{1
command! -complete=file -nargs=1 Rename f <args>|call delete(expand("#"))

" 文字コードを変えて最読込 {{{2
command! -bang -complete=file -nargs=? Utf8
\ edit<bang> ++enc=utf-8 <args>

command! -bang -complete=file -nargs=? Eucjp
\ edit<bang> ++enc=euc-jp <args>

command! -bang -complete=file -nargs=? Sjis
\ edit<bang> ++enc=cp932 <args>

" 文字コードを変換 {{{2
command! -bang -complete=file -nargs=? ToUtf8
\ setlocal fileencoding=utf-8

command! -bang -complete=file -nargs=? ToEucjp
\ setlocal fileencoding=euc-jp

command! -bang -complete=file -nargs=? ToSjis
\ setlocal fileencoding=cp932


" autocmd {{{1
augroup MyAutoCmd
  autocmd!
augroup END

autocmd MyAutoCmd FileType help,quickrun nnoremap <buffer> q <C-w>c

" 自動で書き込み もう少し良い方法探す
"autocmd MyAutoCmd InsertLeave * silent! wall




" キーマップ {{{1
noremap ; :
noremap : ;

nnoremap <Esc><Esc> :<C-u>nohlsearch<Return>

nnoremap j gj
nnoremap k gk

noremap <Space> <Nop>
noremap <S-k> <Nop>

inoremap <C-f> <Right>
inoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>

if has('unix')
	cnoremap <C-x> <C-r>=expand("%:p:h")<CR>/
endif

noremap <C-BS> <C-w>
noremap! <C-BS> <C-w>

noremap <C-h> :<C-u>help<Space>

" .vimrcのロード
nnoremap <C-l> :<C-u>source ~/.vimrc<Return>


" タブ {{{2
nnoremap <C-t> <Nop>
nnoremap <C-t>n :<C-u>tabnew<Return>
nnoremap <C-t>c :<C-u>tabclose<Return>
nnoremap <C-t>o :<C-u>tabonly<Return>
nnoremap <C-t>j :<C-u>tabnext<Return>
nnoremap <C-t>k :<C-u>tabprevious<Return>
nnoremap <C-n> :<C-u>tabnext<Return>
nnoremap <C-p> :<C-u>tabprevious<Return>




" プラグイン {{{1

" ku.vim {{{2
noremap <silent> <Space>kf :<C-u>Ku file<Return>
noremap <silent> <Space>kb :<C-u>Ku buffer<Return>
noremap <silent> <Space>kh :<C-u>Ku history<Return>
"autocmd MyAutoCmd FileType ku inoremap <buffer> <ESC> <ESC>:quit<Return>

" neocomplcache.vim {{{2
let g:NeoComplCache_EnableAtStartup = 1
let g:NeoComplCache_EnableInfo = 1
let g:NeoComplCache_EnableCamelCaseCompletion = 1
let g:NeoComplCache_EnableUnderbarCompletion = 1
let g:NeoComplCache_MinSyntaxLength = 3
let g:NeoComplCache_SkipInputTime = "0.1"
let g:NeoComplCache_SmartCase = 1

let g:NeoComplCache_DictionaryFileTypeLists = {
			\ "default" : "",
			\ "vimshell" : $HOME."/.vimshell_hist"
			\ }

if !exists("g:NeoComplCache_KeywordPatterns")
	let g:NeoComplCache_KeywordPatterns = {}
endif
let g:NeoComplCache_KeywordPatterns["default"] = "\v\h\w*"
let g:NeoComplCache_SnippetsDir = $HOME."/snippets"

inoremap <expr><TAB> pumvisible() ? "\<C-n>" :"\<TAB>"


" skk.vim {{{2
let skk_jisyo = "~/.skk-jisyo"
let skk_large_jisyo = "~/Library/AquaSKK/SKK-JISYO.L"
let skk_auto_save_jisyo = 1
let skk_keep_state = 0
let skk_egg_like_newline = 1
let skk_show_annotation = 1
let skk_use_face = 1


" smartword.vim {{{2
map w <Plug>(smartword-w)
map b <Plug>(smartword-b)
map e <Plug>(smartword-e)
map ge <Plug>(smartword-ge)
noremap W w
noremap B b
noremap E e
noremap gE ge


" spec.vim {{{2
language time en_US.UTF-8
let g:spec_chglog_format = "%a %b %d %Y Hamaco <hamaco_@livedoor.com> -"


" commentop.vim {{{2
map <Leader>c     <Plug>CommentopToggleNV
map <Leader>C     <Plug>CommentopAppendNV
map <Leader><C-c> <Plug>CommentopRemoveNV




" Tmp: 一時的な設定 ============================================ {{{1





" END {{{1
" vim: foldmethod=marker
