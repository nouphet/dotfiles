if has("mac")
	set columns=145
	set lines=55
	set guifont=Ricty:h16
	set transparency=20
	colorscheme mrkn256

	set fuoptions=maxvert,maxhorz
	" au GUIEnter * set fullscreen

	" vim hacks 221
	let g:transparency = &transparency
	function! s:relative_transparency(diff)
		let &transparency = a:diff + &transparency
		let g:transparency = &transparency
	endfunction
	nnoremap <up> :<C-u>call <SID>relative_transparency(5)<CR>
	inoremap <up> <C-o>:call <SID>relative_transparency(5)<CR>
	nnoremap <down> :<C-u>call <SID>relative_transparency(-5)<CR>
	inoremap <down> <C-o>:call <SID>relative_transparency(-5)<CR>
	nnoremap <Space>n :<C-u>nohlsearch<CR>:let &transparency = g:transparency<CR><C-l>
elseif has("unix")
	set columns=110
	set lines=33
	set guifont=Ricty\ Bold\ 16
	colorscheme pyte
elseif has("win32")
	set columns=120
	set lines=40
	"set guifont=ゆたぽん（コーディング）:h12
	set guifont=あくあフォント:h12
	colorscheme h2u_black

	" fullscreen
	"-----------------------------------------------------------
	nnoremap <F11> :call ToggleFullScreen()<CR>
	function! ToggleFullScreen()
		if &guioptions =~# 'C'
			set guioptions-=C
			if exists('s:go_temp')
				if s:go_temp =~# 'm'
					set guioptions+=m
				endif
				if s:go_temp =~# 'T'
					set guioptions+=T
				endif
			endif
			simalt ~r
		else
			let s:go_temp = &guioptions
			set guioptions+=C
			set guioptions-=m
			set guioptions-=T
			simalt ~x
		endif
	endfunction
endif

set linespace=4

set splitbelow " 横分割したら新しいウィンドウは下に
set splitright " 縦分割したら新しいウィンドウは右に

" Sugamo.vim
function! ToggleFont()
	if &guifont=~"あくあフォント"
		set guifont=ゆたぽん（コーディング）:h12
	else
		set guifont=あくあフォント:h12
	endif
endfunction
command! ToggleFont :call ToggleFont()
