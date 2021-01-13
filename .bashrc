#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return



findpkg() {
	    # Find package oMl
	        pacman -Q --color always | grep "$1"
	    }

cleanarch() {
		
		sudo pacman -Scc
		sudo pacman -Rns $(pacman -Qtdq)
		sudo rm -rf /home/xenon/.cache/*
		sudo journalctl --vacuum-size=50M
		echo "Be sure to rmlint"
		
		}

[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

export PATH=$PATH:~/.local/bin

eval "$(starship init bash)"

# PS1='[\u@\h \W]\$ '
# PS1="\[$(tput bold)\]\[$(tput setaf 4)\][\[$(tput setaf 4)\]\u\[$(tput setaf 4)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 4)\]\W\[$(tput setaf 4)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr    0)\]"
