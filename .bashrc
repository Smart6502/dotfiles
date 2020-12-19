#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

findpkg() {
	    # Find package oMl
	        pacman -Q | grep "$1"
	    }

cleanarch() {
		
		sudo pacman -Scc
		sudo pacman -Rns $(pacman -Qtdq)
		sudo rm -rf /home/xenon/.cache/*
		sudo journalctl --vacuum-size=50M
		echo "Be sure to rmlint"
		
		}

[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

PS1='[\u@\h \W]\$ '
