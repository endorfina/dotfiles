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

export PATH=$PATH:$HOME/.local/bin
[[ -d $CARGO_HOME/bin ]] && PATH=$CARGO_HOME/bin:$PATH

export VISUAL=nvim
export EDITOR=$VISUAL
export TERMINAL=alacritty
export BROWSER=firefox

[[ $USER = 'endorfina' ]] && export PS1="\[\e[38;5;255m\]🦩 \[\e[38;5;240m\][\[\e[38;5;245m\]\W\[\e[38;5;240m\]]\[\e[38;5;079m\]\$\[\e[0m\] "

alias dog='tail -n+1'
alias :e='nvim 2>/dev/null'
alias :bd='exit'
alias ta='if tmux -f "$XDG_CONFIG_HOME"/tmux/tmux.conf has &>/dev/null; then tmux -f "$XDG_CONFIG_HOME"/tmux/tmux.conf -u attach && exit; else tmux -f "$XDG_CONFIG_HOME"/tmux/tmux.conf -u && exit; fi'
alias neofetch='clear && echo && neofetch | sed "s~'"$USER"'.*$~[DATA EXPUNGED]~"'
alias lis='ls -lGh'
alias ggs='git status'
alias ggc='git commit'
alias ggo='git checkout'
alias gga='git add'
alias ggu='git add -u'
alias ggr='git restore'
alias ggrs='git restore --staged'
alias ggd='git diff'
alias ggdc='git diff --cached'
alias ggl='git log'
alias ggsps='if git stash; then git pull -r; git stash apply; fi'
alias ignore='echo >> .gitignore'

remove_carriage_returns()
{
    find . -maxdepth 2 -type f -name '*.?pp' | while read -r filename
    do
        printf '%s\n' "${filename#./}"
        sed -i 's~\r$~~' "$filename"
    done
}

todos()
{
    find "${1-.}" -type f -exec grep -H 'TODO:' '{}' '+'
}

edit_modified()
{
    git status --short | sed -En '/^M/{s~^[A-Z]+[[:space:]]*~~;p;}' | sort | uniq | xargs "echo"
}

. ~/.config/broot/launcher/bash/br