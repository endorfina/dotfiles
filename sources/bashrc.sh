export HISTCONTROL=ignoredups
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache
export CARGO_HOME=$XDG_DATA_HOME/cargo
export GRADLE_USER_HOME=$XDG_DATA_HOME/gradle
export LESSKEY=$XDG_CONFIG_HOME/less/lesskey
export LESSHISTFILE=$XDG_CACHE_HOME/less/history
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export SCREENRC=$XDG_CONFIG_HOME/screen/screenrc
export WEECHAT_HOME=$XDG_CONFIG_HOME/weechat

set -o ignoreeof -o vi

[[ -d $HOME/.local/bin && ! $PATH == *$HOME/.local/bin* ]] && export PATH=$PATH:$HOME/.local/bin
[[ -d $CARGO_HOME/bin  && ! $PATH == *$CARGO_HOME/bin* ]]  && export PATH=$CARGO_HOME/bin:$PATH

export VISUAL=nvim
export EDITOR=$VISUAL
export TERMINAL=alacritty
export BROWSER=firefox

[[ $USER = 'endorfina' ]] && export PS1="\[\e[38;5;255m\]🦩 \[\e[38;5;240m\][\[\e[38;5;245m\]\W\[\e[38;5;240m\]]\[\e[38;5;079m\]\$\[\e[0m\] " ## %Linux%

alias dog='tail -n+1'
alias :e='nvim 2>/dev/null'
alias :bd='exit'
alias nice_tmux='tmux -2u -f "$XDG_CONFIG_HOME"/tmux/tmux.conf'
alias ta='if nice_tmux has &>/dev/null; then nice_tmux attach && exit; else nice_tmux && exit; fi'
alias neofetch='clear && echo && neofetch | sed "s~'"$USER"'.*$~[DATA EXPUNGED]~"'
alias lls='ls -lGh'

## Git functions ##

alias ggi='git init -b trunk'
alias ggs='git status'
alias ggc='git commit'
alias ggo='git checkout'
alias ggsm='git submodule'
alias gga='git add'
alias ggu='git add -u'
alias ggr='git restore'
alias ggrs='git restore --staged'
alias ggd='git diff'
alias ggdc='git diff --cached'
alias ggcp='git cherry-pick'
alias ggl='git log'
alias ggl1='git log --oneline'
alias ggpv='git push -v'
alias ggpr='git pull -r --autostash'
alias ignore='echo >> .gitignore'

is_in_path()
{
    while [[ $# -gt 0 ]]
    do
        command -v "$1" &>/dev/null || return 1
        shift
    done
}

is_in_path kstart5 && alias restart_plasma='kquitapp5 plasmashell && kstart5 plasmashell' ## %Linux%
is_in_path pacman && alias remove_orphans='pacman -Qtdq | sudo pacman -Rns' ## %Linux%

ggpu()
{
    local branch
    branch=$(git branch --no-color --show-current) || return 1

    git push -v -u "${1:-origin}" "$branch"
}

ggpa()
{
    local branch
    branch=$(git branch --no-color --show-current) || return 1

    git remote | while read -r remote
    do
        git push -v "$remote" "$branch"
    done
}

ggem()
{
    echo -n '📝 ' >&2
    [[ $# -eq 0 ]] && set -- cat -
    git status --short | sed -En '/^[[:space:]]*M/{s~^[[:space:]]*[A-Z]+[[:space:]]*~~;p;}' | sort | uniq | "$@" | xargs -p "$EDITOR"
}

## Others ##

todos()
{
    local filter=${1:-*}
    shift
    find . -type f -name "$filter" "$@" -exec grep -H 'TODO:' '{}' '+' | sed 's~^\./~~'
}

remove_carriage_returns()
{
    local filter=${1:-*.?pp}
    echo -n "'$filter' 🪓 " >&2

    find . -maxdepth 2 -type f -name "$filter" -exec grep -H '$' '{}' + \
        | sed -e 's~^\./~~' -e 's~:.*$~~' \
        | sort \
        | uniq \
        | xargs -p sed -e 's~\r$~~' \
            -i    # %Linux%
            -i '' # %Darwin%
}

[[ -f ~/.config/broot/launcher/bash/br ]] && . ~/.config/broot/launcher/bash/br ## %Linux%
[[ -f ~/Library/Preferences/org.dystroy.broot/launcher/bash/br ]] && . ~/Library/Preferences/org.dystroy.broot/launcher/bash/br ## %Darwin%
