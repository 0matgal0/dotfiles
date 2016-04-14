# ~/.bashrc: executed by bash(1) for non-login shells.
# examples: /usr/share/doc/bash/examples/startup-files

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Update the values of LINES and COLUMNS, if necessary
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Trim long pwds
export "PROMPT_DIRTRIM=2"

# Disable flow control
stty -ixon

# Autostart tmux & attach to a session if exists
# tmux attach &> /dev/null
# if [[ ! $TERM =~ screen ]]; then
#     exec tmux -2
# fi

# Git-prompt
PS_SYMBOL_LINUX='%'
PS_SYMBOL_ERROR='%'
PS_SYMBOL=$PS_SYMBOL_LINUX
GIT_BRANCH_SYMBOL='=>'
GIT_BRANCH_CHANGED_SYMBOL='+'
GIT_NEED_PUSH_SYMBOL='^'
GIT_NEED_PULL_SYMBOL='*'
FG_RED="\[$(tput setaf 1)\]"
FG_MAGENTA="\[$(tput setaf 5)\]"
FG_YELLOW="\[$(tput setaf 3)\]"
FG_3="\[$(tput setaf 6)\]"
BOLD="\[$(tput bold)\]"
RESET="\[$(tput sgr0)\]"
__git_info() {
        [ -x "$(which git)" ] || return
        local branch="$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)"
        [ -n "$branch" ] || return
        local marks
        [ -n "$(git status --porcelain)" ] && marks+=" $GIT_BRANCH_CHANGED_SYMBOL"
        local stat="$(git status --porcelain --branch | grep '^##' | grep -o '\[.\+\]$')"
        local aheadN="$(echo $stat | grep -o 'ahead \d\+' | grep -o '\d\+')"
        local behindN="$(echo $stat | grep -o 'behind \d\+' | grep -o '\d\+')"
        [ -n "$aheadN" ] && marks+=" $GIT_NEED_PUSH_SYMBOL$aheadN"
        [ -n "$behindN" ] && marks+=" $GIT_NEED_PULL_SYMBOL$behindN"
        printf " $FG_YELLOW($GIT_BRANCH_SYMBOL$branch$marks)"
}
ps1() {
        if [ $? -eq 0 ]; then PS_SYMBOL=$FG_MAGENTA$PS_SYMBOL_LINUX
        else PS_SYMBOL=$FG_RED$PS_SYMBOL_ERROR; fi
        hasjobs=$(jobs -sp)
        PS1="$RESET\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h:\w\a\]"
        PS1+="\w$(__git_info)$RESET$FG_YELLOW${hasjobs:+ (\j)}$RESET$BOLD$PS_SYMBOL $RESET"
}
PROMPT_COMMAND=ps1

# Git pretty log
HASH="%C(yellow)%h%Creset"
RELATIVE_TIME="%Cgreen(%ar)%Creset"
AUTHOR="%C(bold blue)<%an>%Creset"
REFS="%C(bold red)%d%Creset"
SUBJECT="%s"

FORMAT="$HASH}$RELATIVE_TIME}$AUTHOR}$REFS $SUBJECT"

ghead() {
    glog -1
    git show -p --pretty="tformat:"
}

glog() {
    git log --graph --pretty="tformat:${FORMAT}" $* |
        sed -Ee 's/(^[^<]*) ago\)/\1)/' |
        sed -Ee 's/(^[^<]*), [[:digit:]]+ .*months?\)/\1)/' |
        column -s '}' -t |
        sed -Ee "s/(Merge (branch|remote-tracking branch|pull request) .*$)/$(printf $FG_RED)\1$(printf $RESET)/" |
        if [ -n "$GIT_NO_PAGER" ]; then
            cat
        else
            less --quit-if-one-screen --no-init --RAW-CONTROL-CHARS --chop-long-lines
        fi
}

# Aliases
# Git aliases
alias gl=glog
alias gh=ghead
alias gst="git status"
alias gci="git commit --verbose"
alias gco="git checkout"
alias gdi="git diff"
alias gdc="git diff --cached"
alias gamend="git commit --amend"
alias gaa="git add --all"
alias gff="git merge --ff-only"
alias gpullff="git pull --ff-only"
alias gnoff="git merge --no-ff"
alias gfa="git fetch --all"
alias gpom="git push origin master"
alias gb="git branch"
alias gds="git diff --stat=160,120"
alias gdh1="git diff HEAD~1"

# Pretty print all git aliases used
galias() {
echo "alias   full command
$(tput setaf 3)gl[og]  $(tput setaf 12)(git log --graph --pretty=\"tformat:\${FORMAT}\" $)
$(tput setaf 3)gh[ead] $(tput setaf 12)(glog -1 && git show -p --pretty=\"tformat:\")
$(tput setaf 3)gst     $(tput setaf 12)(git status)
$(tput setaf 3)gci     $(tput setaf 12)(git commit --verbose)
$(tput setaf 3)gco     $(tput setaf 12)(git checkout)
$(tput setaf 3)gdi     $(tput setaf 12)(git diff)
$(tput setaf 3)gdc     $(tput setaf 12)(git diff --cached)
$(tput setaf 3)gamend  $(tput setaf 12)(git commit --amend)
$(tput setaf 3)gaa     $(tput setaf 12)(git add --all)
$(tput setaf 3)gff     $(tput setaf 12)(git merge --ff-only)
$(tput setaf 3)gpullff $(tput setaf 12)(git pull --ff-only)
$(tput setaf 3)gnoff   $(tput setaf 12)(git merge --no-ff)
$(tput setaf 3)gfa     $(tput setaf 12)(git fetch --all)
$(tput setaf 3)gpom    $(tput setaf 12)(git push origin master)
$(tput setaf 3)gb      $(tput setaf 12)(git branch)
$(tput setaf 3)gds     $(tput setaf 12)(git diff --stat=160,120)
$(tput setaf 3)gdh1    $(tput setaf 12)(git diff HEAD~1)"
}

# Make tmux use 256 colors
alias tmux="tmux -2"

# Vim man
vman() { vim <(man $1); }

# Path
PATH=$PATH:~/bin/

# Ignore cases of completions
bind 'set completion-ignore-case on'

# Single tab completion
# bind 'set show-all-if-ambiguous on'

# Disable alternate screen in less globally
# export LESS="-X -R"
