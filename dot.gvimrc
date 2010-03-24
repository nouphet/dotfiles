if has("mac")
	set columns=135
	set lines=55
	"set guifont=DejaVu\ Sans\ Mono:h14
	set guifont=Menlo:h14
	set transparency=20
	"colorscheme h2u_black
	colorscheme mrkn256

	set fuoptions=maxvert,maxhorz
	" au GUIEnter * set fullscreen
elseif has("unix")
	set columns=90
	set lines=45
	set guifont=MeiryoKe_Console\ 10
	colorscheme ir_black
elseif has("win32")
	set columns=100
	set lines=35
	set guifont=あずきフォント:h14:cSHIFTJIS
	colorscheme h2u_black
endif

set splitbelow " 横分割したら新しいウィンドウは下に
set splitright " 縦分割したら新しいウィンドウは右に
