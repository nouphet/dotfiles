# .bashrc

# for bash_completion
if [ -f `brew --prefix`/etc/bash_completion ]; then
  source `brew --prefix`/etc/bash_completion
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

# modidy console

if [ $TERM = screen  ]; then
  PS1="\`if [ \$? = 0 ]; then echo \[\e[36m\]\u@$HOSTNAME:\w\[\e[0m\]; else echo \[\e[41m\]\u@$HOSTNAME:\w\[\e[0m\]; fi\`(screen $STY)\n\\$ "
else
  PS1="\`if [ \$? = 0 ]; then echo \[\e[36m\]\u@$HOSTNAME:\w\[\e[0m\]; else echo \[\e[41m\]\u@$HOSTNAME:\w\[\e[0m\]; fi\`\\n\\$ "
fi

# Application Shortcuts
alias cot='open -g -a CotEditor'	# ターミナルからCotEditorを開く
alias coda='open -g -a Coda'		# ターミナルからCodaを開く
alias safari='open -g -a safari'	# ターミナルからSafariを開く
alias console='open -a console'		# ターミナルからコンソールを開く
alias edit='open -g /Applications/PhpStorm.app'		# ターミナルからphpStormを開く

# for shortcut
alias up='cd ..'
alias up2='cd ../..'
alias up3='cd ../../..'
alias up4='cd ../../../..'
alias up5='cd ../../../../..'
#alias ls='ls -G'
alias rm='rm -i'
alias la='ls -al'
alias ll='ls -l'
alias t='tar zxvf'
alias t-='tar xvf -'
alias b='bzip2 -dc'
alias dh='df -h'
alias vi='vim'
alias v='vim'
#alias ping='ping -i 0.2'
alias gomamp="cd /Applications/MAMP/htdocs/"
alias gowww='cd /var/www/html/'
alias getadelie='wget https://raw.github.com/suin/xoops-adelie-debug/master/build/AdelieDebug.class.php'

function go {
	local dir
	dir=$(go-get-path $@)
	result=$?
	[[ $dir ]] && cd $dir
	return $result
}

_go()
{
	local cur prev split=false
	COMPREPLY=()
	_get_comp_words_by_ref -n : cur prev
	COMPREPLY=($(compgen -W "$(go-get-path names)" -- "$cur"))
}
complete -F _go go

#PATH=/Users/nouphet/.rvm/gems/ruby-1.9.3-p194/bin:/Users/nouphet/.rvm/gems/ruby-1.9.3-p194@global/bin:/Users/nouphet/.rvm/rubies/ruby-1.9.3-p194/bin:/Users/nouphet/.rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:~/bin
PATH=/Users/nouphet/.rvm/gems/ruby-1.9.3-p194/bin:$PATH
PATH=/Users/nouphet/.rvm/gems/ruby-1.9.3-p194@global/bin:$PATH
PATH=/Users/nouphet/.rvm/rubies/ruby-1.9.3-p194/bin:$PATH
PATH=/Users/nouphet/.rvm/bin:$PATH
PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:~/bin:$PATH

export PATH=/usr/local/sbin:$PATH # for Homebrew
export PATH=/usr/local/bin:$PATH  # for Homebrew

