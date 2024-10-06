source ~/.profile
#!/usr/bin/env bash

# Path to the bash it configuration
export BASH_IT="~/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# for virtualenvironment - python
source /usr/local/bin/virtualenvwrapper.sh
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3

# Allow C Coding Language (gcc and clang)
export LIBRARY_PATH=/usr/local/lib
export C_INCLUDE_PATH=/usr/local/include
export LD_LIBRARY_PATH=/usr/local/lib
function make50() { 
	gcc "$1".c -o "$1" -I /usr/local/include -L /usr/local/lib -lcs50;
}

# Allow docker
if [ "$(docker inspect -f '{{.State.Running}}' ${container_name} 2>/dev/null)" = "true" ]; then
	eval $(docker-machine env default);
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

# Load Bash It
source "$BASH_IT"/bash_it.sh

# ### Start DotFile
# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;
# ### End DotFile

# Set PATH to Macintosh HD (/)
cd /

# Make an App Display Something When Launched

# Terminal
# osascript -e 'tell app "Terminal" to display dialog "You opened Terminal!"'
# If you want there to be a notification, then use this code: terminal-notifier -message "You opened Terminal!" -title "Terminal Opened" -execute "open -a Terminal" -ignoreDnD

# Stop Making an App Display Something When Launched


# Customize Terminal

symbol="⚡ "

# Changing Colours of Terminal
alias ls='ls -GFh'
export PS1="[\$(~/.bash/Battery.sh)] $(tput setaf 166)$(tput bold)\u$(tput setaf 37)$(tput sgr0)@$(tput bold)$(tput setaf 136)\h$(tput sgr0)$(tput setaf 37): \[\033[35m\]\d \$(tput setaf 37)- $(tput setaf 64)\@ \[\033[31m\]\w \[\033[33;1m\]\$symbol \033[m\]\n"
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagacad

# Stop Customize Terminal


# All Functions

# Preview the Man Page
function preman() {
	man -t $@ | open -f -a "Preview"
}

# XManPage
function xmanpage() {
	open x-man-page://$@
}

#BBMan
function bbman () {
  MANWIDTH=80 MANPAGER='col -bx' man $@ | bbedit --clean --view-top -t "man $@"
}

# End Functions


# All Functions with Aliases

# 
function pwdf () {
	osascript <<EOS
		tell application "Finder"
			if (count of Finder windows) is 0 then
				set dir to (desktop as alias)
			else
				set dir to ((target of Finder window 1) as alias)
			end if
			return POSIX path of dir
		end tell
EOS
} 
alias cdf='pwdf; cd "$(pwdf)"'

# End Functions with Aliases


# All Aliases

# Modify ~/.bash_profile or (now) ~/.b_p
alias .bash_profile="~/.bash_profile"
alias .b_p="sudo nano ~/.bash_profile"

# Hidden Files
alias showHiddenFiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias hideHiddenFiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"

# New Blank Icon in the Dock
alias newDockSpace="defaults write com.apple.dock persistent-apps -array-add '{\"tile-type\"=\"spacer-tile\";}'; killall Dock;"

# New Small Blank Icon in the Dock
alias smallNewDockSpace="defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'; killall Dock"

# Recent Items in the Dock
alias recentItems="defaults write com.apple.dock persistent-others -array-add '{ "tile-data" = { "list-type" = 1; }; "tile-type" = "recents-tile"; }'; killall Dock"

# Display Message at Lock Screen
alias lockScreenMessage="sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "

# Shutdown/Restart
alias shutdown="sudo shutdown -h now"
alias restart="sudo shutdown -r now"

# Neat
alias cl="clear"

# Directories
alias ~="cd ~/"
alias ..="cd .."
alias ...="cd ../.."
alias OneDrive="cd ~/OneDrive/"

# Save Myself From Me
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

# Finder
alias reveal="open -R"
alias Finder="open -a /System/Library/CoreServices/Finder.app"

# Make it easier
alias l="ls"

# Non-Active Apps in the Dock
alias hideNonActiveApps="defaults write com.apple.dock static-only -bool TRUE; killall Dock"
alias showNonActiveApps="defaults write com.apple.dock static-only -bool FALSE; killall Dock"

# Hide/Unhide Specific Files
alias hide="chflags hidden "
alias unhide="chflags nohidden "

# Python
alias py="python "
alias py3="python3 "

# Built-In
alias calculator="bc -l"

# Date and Time
alias time="date '+The time is: %T'"
alias date="date '+The date is: %d/%m/%Y'"

# Root
alias root="dsenableroot"
alias exitroot="dsenableroot -d"

# Terminal Bell
alias bell="tput bel"

# Link a Finder directory with another
alias link="ls -n"

# Edit Mac-Booting Logo and Stuff, Apple logo, OtherUser Logo, Shutdown Logo... Make it writable
alias MacReadWriteResources="sudo mount -rw /; sudo chmod 777 /System/Library/PrivateFrameworks/LoginUIKit.framework/Versions/A/Frameworks/LoginUICore.framework/Versions/A/Resources; killall Finder;"

# Open Sublime Text
alias s='open -a "Sublime Text"'

# Download files offline with the URL
alias download="curl  -O "

# Securely Compress Files to zip with password encryption
alias pwdFile="zip -e "

# Watch Star Wars Episode 4 in ASCII
alias starwars="telnet towel.blinkenlights.nl"

alias openEcho="nc -v -ul "
function connectEcho() {
	nc $@ -u $@
}
# Password - Protected Zip
alias ppZip="sudo zip -e "

# Find all IP's With Port: 1234 Open
alias ipport1234="nmap -p1234,65534 -O 192.168.1.1/24"

# Switch to Zsh
alias zsh="exec /bin/zsh"

# Switch to Bash
alias bash="exec bash -l"

# Switch to Fish
alias fish="exec fish -l"

# Switch to Csh
alias csh="exec csh -l"

# Switch to Tcsh
alias tcsh="exec tcsh -l"

# Switch to SH
alias SH="exec sh -l"

# Locate any item
alias Find="locate"

# Locate any item Case-Insensitive
alias find="locate -i"

# Matrix
alias matrix='LC_ALL=C tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"'

# Open Empire
alias empire="docker run -it empireproject/empire"
# Stop Aliases


# Make Notifications last for a certain amount of time before going away
defaults write com.apple.notificationcenterui bannerTime 3

# Setting PATH for Python 2.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH

############################################
# Fill with minuses
 
# (this is recalculated every time the prompt is shown in function prompt_command):
 
fill="--- "
 
 
reset_style='\[\033[00m\]'
 
status_style=$reset_style'\[\033[0;90m\]' # gray color; use 0;37m for lighter color
 
prompt_style=$reset_style
 
command_style=$reset_style'\[\033[1;29m\]' # bold black
 
# Prompt variable: 
function BatteryShow() {
#!/bin/bash
#
# battery status script
#

BATTERY=/proc/acpi/battery/BAT0

REM_CAP=`grep "^remaining capacity" $BATTERY/state | awk '{ print $3 }'`
FULL_CAP=`grep "^last full capacity" $BATTERY/info | awk '{ print $4 }'`
BATSTATE=`grep "^charging state" $BATTERY/state | awk '{ print $3 }'`

CHARGE=`echo $(( $REM_CAP * 100 / $FULL_CAP ))`

NON='\033[00m'
BLD='\033[01m'
RED='\033[01;31m'
GRN='\033[01;32m'
YEL='\033[01;33m'

COLOUR="$RED"

case "${BATSTATE}" in
   'charged')
   BATSTT="$BLD=$NON"
   ;;
   'charging')
   BATSTT="$BLD+$NON"
   ;;
   'discharging')
   BATSTT="$BLD-$NON"
   ;;
esac

# prevent a charge of more than 100% displaying
if [ "$CHARGE" -gt "99" ]
then
   CHARGE=100
fi

if [ "$CHARGE" -gt "15" ]
then
   COLOUR="$YEL"
fi

if [ "$CHARGE" -gt "30" ]
then
   COLOUR="$GRN"
fi

echo -e "${COLOUR}${CHARGE}%${NON} ${BATSTT}"

# end of file
}

battery_status()
{
RED='\033[01;31m'
COLOUR="$RED"

echo -e `${COLOUR}ioreg -n AppleSmartBattery -r | awk '$1~/Capacity/{c[$1]=$3} END{OFMT="%.2f%%"; max=c["\"MaxCapacity\""]; print (max>0? 100*c["\"CurrentCapacity\""]/max: "?")}'%`
}

function battery {
ioreg -n AppleSmartBattery -r | awk '$1~/Capacity/{c[$1]=$3} END{OFMT="%.2f%%"; max=c["\"MaxCapacity\""]; print (max>0? 100*c["\"CurrentCapacity\""]/max: "?")}'
}

PS1="$status_style"'$fill \t\n'"$prompt_style"'${debian_chroot:+($debian_chroot)}[$(battery)]$(tput setaf 166)$(tput bold)\u$(tput setaf 37)$(tput sgr0)@$(tput bold)$(tput setaf 136)\h$(tput sgr0)$(tput setaf 37): \[\033[35m\]\d $(tput setaf 37)- $(tput setaf 64)\@ \[\033[31m\]\w \[\033[33;1m\]⚡ \033[m\]\n'

# Reset color for command output
 
# (this one is invoked every time before a command is executed):
 
trap 'echo -ne "\033[00m"' DEBUG
 
 
function prompt_command {
 
 
# create a $fill of all screen width minus the time string and a space:
 
let fillsize=${COLUMNS}-16
 
fill=""
 
while [ "$fillsize" -gt "0" ]
 
do
 
fill="-${fill}" # fill with underscores to work on
 
let fillsize=${fillsize}-1
 
done
 
 
# If this is an xterm set the title to user@host:dir
 
case "$TERM" in
 
xterm*|rxvt*)
 
bname=`basename "${PWD/$HOME/~}"`
 
echo -ne "\033]0;${bname}: ${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"
 
;;
 
*)
 
;;
 
esac
 
 
}
 
PROMPT_COMMAND=prompt_command
############################################ 

echo Welcome! You are now using BASH!
export GPG_TTY=$(tty)
export THEOS=~/theos

clear

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/usr/local/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

source ~/.profile

if [ -f ~/.bash_profile.local ]; then
    source ~/.bash_profile.local
fi
