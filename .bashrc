# alemi ~/.bashrc
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

stty -ixon		# Disable CTRL-S (pauses terminal)

# Add my .local/bin to path
export PATH="$PATH:$HOME/.local/bin"

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# allow Termite to open another terminal in same working dir
if [[ $TERM == xterm-termite ]]; then
  . /etc/profile.d/vte.sh
  __vte_prompt_command
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# set editor
EDITOR=vim

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color|*termite) color_prompt=yes;;
esac

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable Powerline Go
PWGOMODULES="venv,ssh,cwd,perms,git,hg,jobs,exit,root"
PWGOTHEME="/home/alemi/.config/powerline-go/custom.json"

function _update_ps1() {
    PS1="$(powerline-go -ignore-repos $HOME -modules $PWGOMODULES -max-width 80 -theme $PWGOTHEME -error $?)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
	alias ncdu='ncdu --color=dark'

	# colored GCC warnings and errors
	export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
fi


# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# print all term colors
function show_colors() {
	for x in {0..8}; do 
	    for i in {30..37}; do 
	        for a in {40..47}; do 
	            echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "
	        done
	        echo
	    done
	done
	echo ""
}

