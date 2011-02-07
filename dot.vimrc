" Initialize: {{{1

" Windowsでも.vimを読み込むようにする
set runtimepath& runtimepath+=$HOME/.vim

" has('win32') || has('win64')はめんどい
" http://github.com/Shougo/shougo-s-github/blob/master/vim/.vimrc
let s:iswindows = has('win32') || has('win64')

" pathogen
" http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
runtime bundle/vim-pathogen/autoload/pathogen.vim
if exists("g:loaded_pathogen")
	call pathogen#runtime_append_all_bundles()
end

set nocompatible
filetype plugin indent on

if has("syntax")
	syntax enable
	"set t_Co=256
	if !exists("g:colors_name")
		"colorscheme mrkn256
		colorscheme ap_dark8
	endif
endif




" 文字コード設定 {{{1
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif



" Option: オプション設定 ========================================= {{{1
set ambiwidth=double
set autoindent
"set autowrite
set backspace=indent,eol,start
set backup
set backupcopy&
set backupdir=~/.vim/backup/
set backupskip&
set cdpath+=/web/*
set cinoptions=:0,(0,W1s
set clipboard=unnamed
set directory=~/.vim/swap/
set formatoptions=tcroqnlM1
set history=100
set hlsearch
set ignorecase
set imdisable
set incsearch
set laststatus=2
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<
set modeline
set mouse=a
set nrformats="hex"
set pastetoggle=<F12>
set ruler
set shiftwidth=2
set showcmd
set showmode
set showtabline=2
set smartcase
set softtabstop=2
set splitbelow
set splitright
"set tags& tags+=~/.tags
set updatetime=3000
set tabstop=2
set title
set visualbell t_vb=
set wildmenu
set wildmode=list:longest

if has("unix")
	set nofsync
	set swapsync=
endif

let &statusline = ''
let &statusline .= '%<%f %y%m%r'
let &statusline .= '  %{cfi#get_func_name()}()'
let &statusline .= '%='
let &statusline .= '[%{&l:fileencoding == "" ? &encoding : &l:fileencoding}:%{&ff}]'
"let &statusline .= '%{eskk#statusline()}'
let &statusline .= '  %-14.(%l,%c%V%) %P'

let mapleader = ","
let maplocalleader = "."



" autocmd {{{1
augroup MyAutoCmd
  autocmd!
augroup END

autocmd MyAutoCmd FileType git-diff,help,quickrun,quickfix,qf,ref nnoremap <buffer> q <C-w>c
autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep if len(getqflist()) != 0 | copen | endif

autocmd MyAutoCmd BufEnter *vimshell set listchars=tab:\ \ ,extends:>,precedes:<
autocmd MyAutoCmd BufLeave *vimshell set listchars=tab:>-,trail:-,extends:>,precedes:<

autocmd MyAutoCmd FileType unite imap <buffer> ' <Plug>(unite_quick_match_default_action)
autocmd MyAutoCmd FileType unite nmap <buffer> ' <Plug>(unite_quick_match_default_action)


if !has('gui_running') && !s:iswindows
   " .vimrcの再読込時にも色が変化するようにする
   autocmd MyAutoCmd BufWritePost $MYVIMRC nested source $MYVIMRC
else
   " .vimrcの再読込時にも色が変化するようにする
   autocmd MyAutoCmd BufWritePost $MYVIMRC source $MYVIMRC | 
               \if has('gui_running') | source $MYGVIMRC
   autocmd MyAutoCmd BufWritePost $MYGVIMRC if has('gui_running') | source $MYGVIMRC
endif




" プラグイン {{{1

" 無効化 {{{2
let plugin_dicwin_disable = 1

if s:iswindows
	let g:loaded_gist_vim = 1
	let g:loaded_lingr_vim = 1
endif


" altercmd.vim {{{2
call altercmd#load()
AlterCommand t tabedit
AlterCommand s set
AlterCommand sl setl
AlterCommand sf setf


" capslock.vim {{{2
imap <C-a> <C-o><Plug>CapsLockToggle


" ChangeLog {{{2
let g:changelog_username = "hamaco <hamanaka.kazuhiro@gmail.com>"
let g:changelog_timeformat = "%Y-%m-%d"


" emap.vim {{{2
call emap#load('noprefix')
call emap#set_sid_from_sfile(expand('<sfile>'))


" FavStar.vim {{{2
let g:favstar_user = 'hamaco'


" git.vim {{{2
let g:git_no_map_default = 1
let g:git_command_edit = 'rightbelow vnew'
nnoremap <Space>gd :<C-u>GitDiff --cached<Enter>
nnoremap <Space>gD :<C-u>GitDiff<Enter>
nnoremap <Space>gs :<C-u>GitStatus<Enter>
nnoremap <Space>gl :<C-u>GitLog<Enter>
nnoremap <Space>gL :<C-u>GitLog -u \| head -10000<Enter>
nnoremap <Space>ga :<C-u>GitAdd<Enter>
nnoremap <Space>gA :<C-u>GitAdd <cfile><Enter>
nnoremap <Space>gc :<C-u>GitCommit<Enter>
nnoremap <Space>gC :<C-u>GitCommit --amend<Enter>
nnoremap <Space>gp :<C-u>Git push



" neocomplcache.vim {{{2
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 0
let g:neocomplcache_enable_underbar_completion = 1

"let g:neocomplcache_enable_info = 1 " deleted?
let g:neocomplcache_enable_skip_completion = 1
let g:neoComplcache_partial_match = 0
let g:neocomplcache_enable_ignore_case = 0
let g:neocomplcache_enable_wildcard = 0
let g:neocomplcache_max_list = 30
" let g:NeoComplCache_PreviousKeywordCompletion = 0
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_min_keyword_length = 3
let g:neocomplcache_skip_input_time = "0.1"
let g:neocomplcache_skip_completion_time = "0.1"
"tmp
let g:neocomplcache_auto_completion_start_length = 2
let g:neocomplcache_manual_completion_start_length = 0
let g:neocomplcache_tags_completion_start_length = 5
let g:neocomplcache_caching_limit_file_size = 10240
"let g:NeoComplCache_EnableMFU = 1
"let g:NeoComplCache_SimilarMatch = 1
"let g:NeoComplCache_TryKeywordCompletion = 1

let g:neocomplcache_enable_quick_match = 0 " 数字で候補選択をyuu効
if !exists('g:neocomplcache_quick_match_patterns')
  let g:neocomplcache_quick_match_patterns = {}
endif
let g:neocomplcache_quick_match_patterns.default = ' '
let g:neocomplcache_quick_match_table = {
			\'a' : 1, 's' : 2, 'd' : 3, 'f' : 4, 'g' : 5, 'h' : 6, 'j' : 7, 'k' : 8, 'l' : 9, ';' : 10,
			\'q' : 11, 'w' : 12, 'e' : 13, 'r' : 14, 't' : 15, 'y' : 16, 'u' : 17, 'i' : 18, 'o' : 19, 'p' : 20,
			\ }

let g:neocomplcache_dictionary_filetype_lists = {
			\ 'default'  : '',
			\ 'vimshell' : $HOME.'/.vimshell/command-history'
			\ }


" Enable omni completion.
"autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
let g:neocomplcache_omni_functions = {
			\ 'ruby': 'rubycomplete#Complete',
			\ }

if !exists('g:neocomplcache_omni_patterns')
	let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php  = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

if !exists('g:neocomplcache_keyword_patterns')
	let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns["default"] = "\h\w*"

let g:neocomplcache_snippets_dir = $HOME."/.vim/snippets"
command! -nargs=* Nes NeoComplCacheEditSnippets <args>

imap <silent><C-k>   <Plug>(neocomplcache_snippets_expand)
smap <silent><C-k>   <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g> neocomplcache#undo_completion()
"inoremap <expr><C-l> neocomplcache#complete_common_string()

inoremap <expr><C-h> neocomplcache#smart_close_popup() . "\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup() . "\<C-h>"
inoremap <expr><TAB> pumvisible() ? "\<C-n>" :"\<TAB>"
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
inoremap <expr><C-y> neocomplcache#close_popup()
inoremap <expr><C-e> neocomplcache#cancel_popup()

" vim hacks #135
inoremap <expr> ] searchpair('\[', '', '\]', 'nbW', 'synIDattr(synID(line("."), col("."), 1), "name") =~? "String"') ? ']' : "\<C-n>"


" poslist.vim {{{2
map <C-o> <Plug>(poslist-prev-pos)
map <C-i> <Plug>(poslist-next-pos)


" quickrun.vim {{{2
let g:quickrun_direction = 'rightbelow vertical'
let g:quickrun_no_default_key_mappings = 0 " suspend to map <leader>r

let g:quickrun_config = {}
if has('clientserver') && v:servername != ''
	let g:quickrun_config['*'] = {'runmode': 'async:remote:vimproc'}
else
	let g:quickrun_config['*'] = {'runmode': 'simple'}
endif
let g:quickrun_config.haskell = {'command': 'runghc'}
let g:quickrun_config.asm = {'command': 'gcc', 'exec': ['gcc %s -o ./aaaaa', './aaaaa', 'rm ./aaaaa']}
let g:quickrun_config['ruby.rspec'] = {'command': 'spec'}
let g:quickrun_config.textile = {
			\ 'command': 'redcloth',
			\ 'tempfile': '{tempname()}.textile',
			\ 'exec': ['%c %s > %s:p:r.html', 'open %s:p:r.html', 'sleep 1', 'rm %s:p:r.html'] }


" ref.vim {{{2
" vimprocを使用すると上手く動かない
let g:ref_use_vimproc = 0
if s:iswindows
	let g:ref_phpmanual_path = $HOME . '\share\phpmanual'
else
	let g:ref_phpmanual_path = $HOME . '/share/phpmanual'
endif

let g:ref_alc_use_cache = 1

noremap <Space>ra :<C-u>Ref alc<Space>
noremap <Space>rm :<C-u>Ref man<Space>


"eskk.vim {{{2
let g:eskk#keep_state_beyond_buffer = 0

if has('vim_starting')
	let g:eskk#dictionary = '~/.skk-jisyo'

	if s:iswindows
		let g:eskk#large_dictionary = expand('~/SKK-JISYO.L')
	elseif has('mac')
		let g:eskk#large_dictionary = expand('~/Library/Application\ Support/AquaSKK/SKK-JISYO.L')
	elseif has('unix')
		let g:eskk#large_dictionary = expand('/usr/share/skk/SKK-JISYO.L')
	endif
endif

"let g:eskk_debug = 0
"let g:eskk_egg_like_newline = 1
"let g:eskk_enable_completion = 1
"let g:eskk_ignore_continuous_sticky = 1
""let g:eskk_no_default_mappings = 1
"let g:eskk_revert_henkan_style = 'okuri'

""map! <C-j> <Plug>(eskk:enable)



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
let g:spec_chglog_format = "%a %b %d %Y hamaco <hamanaka.kazuhiro@gmail.com> -"


" surround.vim {{{2
map <Leader>q <Plug>Csurround w"
map <Leader>sq <Plug>Csurround w'
map <Leader>` <Plug>Csurround w`


" unite.vim {{{2
noremap <silent> <Space>uu  :<C-u>Unite -buffer-name=files -start-insert buffer file file_mru <CR>
noremap <silent> <Space>uf  :<C-u>Unite -buffer-name=files -start-insert file<CR>
noremap <silent> <Space>ub  :<C-u>UniteWithBufferDir -buffer-name=files -start-insert file<CR>
noremap <silent> <Space>uc  :<C-u>UniteWithCurrentDir -buffer-name=files -start-insert file<CR>
noremap <silent> <Space>ut  :<C-u>Unite -immediately tab:no-current<CR>
noremap <silent> <Space>uw  :<C-u>Unite -immediately window:no-current<CR>
noremap <silent> <Space>uo  :<C-u>Unite outline<CR>
if s:iswindows
	noremap <silent> <Space>ue  :<C-u>Unite -start-insert everything<CR>
endif
" Execute help.
nnoremap <C-h>  :<C-u>Unite -start-insert help<CR>
" Execute help by cursor keyword.
nnoremap <silent> g<C-h>  :<C-u>UniteWithCursorWord -start-insert help<CR>

let g:unite_enable_ignore_case = 1
let g:unite_enable_split_vertically = 0
let g:unite_enable_start_insert = 0
let g:unite_source_file_mru_limit = 150


call unite#custom_alias('file', 'h', 'left')
call unite#custom_alias('file', 'l', 'right')
call unite#custom_alias('file', 'to', 'tabopen')


call unite#set_substitute_pattern('files', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/*"', 2)
call unite#set_substitute_pattern('files', '^@', '\=getcwd()."/*"', 1)
call unite#set_substitute_pattern('files', '^\\', '~/*')
call unite#set_substitute_pattern('files', '^;v', '~/.vim/*')
call unite#set_substitute_pattern('files', '\*\*\+', '*', -1)

if s:iswindows
else
	call unite#set_substitute_pattern('files', ';w', '/web')
end


" vimfiler.vim {{{2
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_edit_command = "edit"


" vimshell.vim {{{2
let g:vimshell_user_prompt = 'getcwd()'
"let g:vimshell_right_prompt = 'vimshell#vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
let g:vimshell_external_history_path = expand('~/.zsh_histfile')
let g:vimshell_smart_case = 1
let g:vimshell_max_command_history = 10000
let g:vimshell_cd_command = 'TabpageCD'

if s:iswindows
	" Display user name on Windows.
	let g:vimshell_prompt = $USERNAME."% "
elseif has('mac')
	" Display user name on Mac.
	"let g:vimshell_prompt = "/ _ / ×"
	let g:vimshell_prompt = $USERNAME."% "
else
	" Display user name on Linux.
	let g:vimshell_prompt = $USER."% "
endif

noremap <C-Space> :<C-u>VimShell<CR>


" zen-coding.vim {{{2
let g:user_zen_expandabbr_key = '<C-e>'




" key mappings {{{1
nnoremap <Space>ev :<C-u>tabedit $MYVIMRC<CR>
nnoremap <Space>eg :<C-u>tabedit $MYGVIMRC<CR>
nnoremap <Space>rv :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif<CR>
nnoremap <Space>rg :<C-u>source $MYGVIMRC<CR>

nnoremap <Space>em :<C-u>tabedit ~/Dropbox/diary.txt<CR>

nnoremap Y y$

noremap ; :
noremap : ;

nnoremap j gj
nnoremap k gk
nnoremap gh ^
nnoremap gl $

noremap <Space> <Nop>
"noremap <S-k> <Nop>
noremap <S-q> <Nop>

nnoremap <Space>w :<C-u>write<CR>
nnoremap <Space>q :<C-u>quit<CR>

" Emacsっぽいキーバインド {{{2
inoremap <C-x><C-s> <C-o>:<C-u>write<CR>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
"inoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>

inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

noremap <C-BS> <C-w>
noremap! <C-BS> <C-w>

cnoremap <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
"}}}

nnoremap <Space><Esc> :<C-u>nohlsearch<CR>
nnoremap vv <C-v>

cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

if has("unix")
	cnoremap <C-x> <C-r>=expand("%:p:h")<CR>/
endif

vnoremap * "zy:let @/ = @z<CR>n



" タブ {{{2
nnoremap <C-t> <Nop>
nnoremap <C-t>n :<C-u>tabnew<CR>
nnoremap <C-t>c :<C-u>tabclose<CR>
nnoremap <C-t>o :<C-u>tabonly<CR>
nnoremap <C-t>h :<C-u>tabprevious<CR>
nnoremap <C-t>l :<C-u>tabnext<CR>
nnoremap <C-p> :<C-u>tabprevious<CR>
nnoremap <C-n> :<C-u>tabnext<CR>




" commands {{{1
command! -complete=file -nargs=1 Rename f <args>|call delete(expand("#"))

" 文字コードを変えて最読込 {{{2
command! -bang -complete=file -nargs=? Utf8
\ edit<bang> ++enc=utf-8 <args>

command! -bang -complete=file -nargs=? Eucjp
\ edit<bang> ++enc=euc-jp <args>

command! -bang -complete=file -nargs=? Sjis
\ edit<bang> ++enc=cp932 <args>

" 文字コードを変換 {{{2
command! -bang -nargs=0 ToUtf8
\ setlocal fileencoding=utf-8

command! -bang -nargs=0 ToEucjp
\ setlocal fileencoding=euc-jp

command! -bang -nargs=0 ToSjis
\ setlocal fileencoding=cp932

" カレントディレクトリ変更{{{2

" :TabpageCD - wrapper of :cd to keep cwd for each tabpage  "{{{

AlterCommand cd  TabpageCD

Map [n] ,cd       :<C-u>TabpageCD %:p:h<CR>
Map [n] <Space>cd :<C-u>lcd %:p:h<CR>

command!
\   -bar -complete=dir -nargs=?
\   CD
\   TabpageCD <args>

command!
\   -bar -complete=dir -nargs=?
\   TabpageCD
\   execute 'cd' fnameescape(expand(<q-args>))
\   | let t:cwd = getcwd()

autocmd TabEnter *
\   if exists('t:cwd') && !isdirectory(t:cwd)
\ |     unlet t:cwd
\ | endif
\ | if !exists('t:cwd')
\ |   let t:cwd = getcwd()
\ | endif
\ | execute 'cd' fnameescape(expand(t:cwd))
" }}}


" CommandGrep {{{2
function! C(cmd)
	redir => result
	silent execute a:cmd
	redir END
	return result
endfunction

" Grep({text}, {pat} [, invert])
function! Grep(text, pat, ...)
	let op = a:0 && a:1 ? '!~#' : '=~#'
	return join(filter(split(a:text, "\n"), 'v:val' . op . 'a:pat'), "\n")
endfunction

function! Cgrep(cmd, pat, ...)
	return Grep(C(a:cmd), a:pat, a:0 && a:1)
endfunction

function! s:cgrep(args, v)
	let list = matchlist(a:args, '^\v(/.{-}\\@<!/|\S+)\s+(.+)$')
	if empty(list)
		echomsg 'Cgrep: Invalid arguments: ' . a:args
		return
	endif
	let pat = list[1] =~ '^/.*/$' ? list[1][1 : -2] : list[1]
	echo Cgrep(list[2], pat, a:v)
endfunction

command! -nargs=+ -bang Cgrep call s:cgrep(<q-args>, <bang>0)




" Tmp: 一時的な設定 ============================================ {{{1

let g:php_localvarcheck_enable = 0


" vim hacks #106
command! Big wincmd _ | wincmd |

" vim hacks #130
" http://webtech-walker.com/archive/2010/03/17093357.html
command! -complete=file -nargs=+ Grep call s:grep([<f-args>])
function! s:grep(args)
	let target = len(a:args) > 1 ? join(a:args[1:]) : '**/*'
	execute 'vimgrep' '/' . a:args[0] . '/j ' . target
	if len(getqflist()) != 0 | copen | endif
endfunction

" vim hacks #141
" Flip Arguments {{{
"   f(a, b) to f(b, a) when your cursol is on '('.
function! FlipArguments()
  normal! y%
  let @" = split(system('flipper "' . @" . '"'), "\n")[0]
  execute "normal! %p\<C-o>d%"
endfunction
nnoremap <space>flip :<C-u>call FlipArguments()<Cr>
" }}}

" kana's useful tab function {{{
function! s:move_window_into_tab_page(target_tabpagenr)
	" Move the current window into a:target_tabpagenr.
	" If a:target_tabpagenr is 0, move into new tab page.
	if a:target_tabpagenr < 0  " ignore invalid number.
		return
	endif
	let original_tabnr = tabpagenr()
	let target_bufnr = bufnr('')
	let window_view = winsaveview()

	if a:target_tabpagenr == 0
		tabnew
		tabmove  " Move new tabpage at the last.
		execute target_bufnr 'buffer'
		let target_tabpagenr = tabpagenr()
	else
		execute a:target_tabpagenr 'tabnext'
		let target_tabpagenr = a:target_tabpagenr
		topleft new  " FIXME: be customizable?
		execute target_bufnr 'buffer'
	endif
	call winrestview(window_view)

	execute original_tabnr 'tabnext'
	if 1 < winnr('$')
		close
	else
		enew
	endif

	execute target_tabpagenr 'tabnext'
endfunction " }}}
" <space>ao move current buffer into a new tab.
nnoremap <silent> <Space>ao :<C-u>call <SID>move_window_into_tab_page(0)<Cr>

" vim hacks #181
" Open junk file."{{{
command! -nargs=0 JunkFile call s:open_junk_file()
function! s:open_junk_file()
  let l:junk_dir = $HOME . '/.vim_junk'. strftime('/%Y/%m')
  if !isdirectory(l:junk_dir)
    call mkdir(l:junk_dir, 'p')
  endif

  let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))
  if l:filename != ''
    execute 'edit ' . l:filename
  endif
endfunction "}}}

" vim hacks #149
let s:coding_styles = {}
let s:coding_styles['My style']      = 'setl expandtab   tabstop=4 shiftwidth=4 softtabstop&'
let s:coding_styles['Short indent']  = 'setl expandtab   tabstop=2 shiftwidth=2 softtabstop&'
let s:coding_styles['GNU']           = 'setl expandtab   tabstop=8 shiftwidth=2 softtabstop=2'
let s:coding_styles['BSD']           = 'setl noexpandtab tabstop=8 shiftwidth=4 softtabstop&'
let s:coding_styles['Linux']         = 'setl noexpandtab tabstop=8 shiftwidth=8 softtabstop&'

command!
\   -bar -nargs=1 -complete=customlist,s:coding_style_complete
\   CodingStyle
\   execute get(s:coding_styles, <f-args>, '')

function! s:coding_style_complete(...) "{{{
    return keys(s:coding_styles)
endfunction "}}}


" vim hacks #159
nmap <Space>sj <SID>(split-to-j)
nmap <Space>sk <SID>(split-to-k)
nmap <Space>sh <SID>(split-to-h)
nmap <Space>sl <SID>(split-to-l)

nnoremap <SID>(split-to-j) :<C-u>execute 'belowright' (v:count == 0 ? '' : v:count) 'split'<CR>
nnoremap <SID>(split-to-k) :<C-u>execute 'aboveleft'  (v:count == 0 ? '' : v:count) 'split'<CR>
nnoremap <SID>(split-to-h) :<C-u>execute 'topleft'    (v:count == 0 ? '' : v:count) 'vsplit'<CR>
nnoremap <SID>(split-to-l) :<C-u>execute 'botright'   (v:count == 0 ? '' : v:count) 'vsplit'<CR>

" vim hacks #161
nnoremap <sid>(command-line-enter) q:
xnoremap <sid>(command-line-enter) q:
nnoremap <sid>(command-line-norange) q:<C-u>

nmap :  <sid>(command-line-enter)
xmap :  <sid>(command-line-enter)

autocmd MyAutoCmd CmdwinEnter * call s:init_cmdwin()
function! s:init_cmdwin()
  nnoremap <buffer> q :<C-u>quit<CR>
  nnoremap <buffer> <TAB> :<C-u>quit<CR>
  inoremap <buffer><expr><CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
  inoremap <buffer><expr><C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
  inoremap <buffer><expr><BS> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"

  " Completion.
  inoremap <buffer><expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

  startinsert!
endfunction

" buffer
nnoremap s <Nop>
nnoremap ss s
nnoremap sh <C-w>h:call <SID>good_width()<Cr>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l:call <SID>good_width()<Cr>
nnoremap sH <C-w>H:call <SID>good_width()<Cr>
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L:call <SID>good_width()<Cr>

function! s:good_width()
  if winwidth(0) < 84
    vertical resize 84
  endif
endfunction


" Scounter
function! Scouter(file, ...)
  let pat = '^\s*$\|^\s*"'
  let lines = readfile(a:file)
  if !a:0 || !a:1
    let lines = split(substitute(join(lines, "\n"), '\n\s*\\', '', 'g'), "\n")
  endif
  return len(filter(lines,'v:val !~ pat'))
endfunction
command! -bar -bang -nargs=? -complete=file Scouter
\        echo Scouter(empty(<q-args>) ? $MYVIMRC : expand(<q-args>), <bang>0)
command! -bar -bang -nargs=? -complete=file GScouter
\        echo Scouter(empty(<q-args>) ? $MYGVIMRC : expand(<q-args>), <bang>0)


" HighlightWith
command! -nargs=+ -range=% HighlightWith <line1>,<line2>call s:highlight_with(<q-args>)
xnoremap [Space]h :HighlightWith<Space><C-f>

function! s:highlight_with(args) range
	if a:firstline == 1 && a:lastline == line('$')
		return
	endif
	let c = get(b:, 'highlight_count', 0)
	let ft = matchstr(a:args, '^\w\+')
	if globpath(&rtp, 'syntax/' . ft . '.vim') == ''
		return
	endif
	unlet! b:current_syntax
	let save_isk= &l:isk  " For scheme.
	execute printf('syntax include @highlightWith%d syntax/%s.vim',
				\              c, ft)
	let &l:isk= save_isk
	execute printf('syntax region highlightWith%d start=/\%%%dl/ end=/\%%%dl$/ '
				\            . 'contains=@highlightWith%d',
				\             c, a:firstline, a:lastline, c)
	let b:highlight_count = c + 1
endfunction"}}}

if filereadable(expand('~/.vimrc.local'))
	source ~/.vimrc.local
endif

" END {{{1
" vim: foldmethod=marker
