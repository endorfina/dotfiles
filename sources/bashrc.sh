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

[[ -f ~/.local/share/blesh/ble.sh && $- == *i* ]] && . ~/.local/share/blesh/ble.sh --noattach

set -o ignoreeof -o vi

[[ -d $HOME/.local/bin && ! :$PATH: == *:$HOME/.local/bin:* ]] && export PATH=$PATH:$HOME/.local/bin
[[ -d $CARGO_HOME/bin  && ! :$PATH: == *:$CARGO_HOME/bin:* ]]  && export PATH=$CARGO_HOME/bin:$PATH

export VISUAL=nvim
export EDITOR=$VISUAL
export TERMINAL=alacritty
export BROWSER=firefox

[[ $USER = 'endorfina' ]] && export PS1="\[\e[38;5;255m\]🦩 \[\e[38;5;240m\][\[\e[38;5;245m\]\W\[\e[38;5;240m\]]\[\e[38;5;079m\]\$\[\e[0m\] " ## %Linux%

alias dog='tail -n+1'
alias :e='nvim 2>/dev/null'
alias :bd='exit'
alias u_tmux='tmux -2u -f "$XDG_CONFIG_HOME"/tmux/tmux.conf'
alias attach_tmux='u_tmux attach && exit'
alias start_tmux='[[ -d /var/love ]] && cd /var/love ; u_tmux && exit'
alias ta='if u_tmux has >/dev/null; then attach_tmux; else start_tmux; fi'
alias neofetch='clear && echo && neofetch | sed "s~'"$USER"'.*$~[DATA EXPUNGED]~"'

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

alias myip='curl ipinfo.io/ip'
alias ports='netstat -tulanp'
alias untar='tar -zxvf'
alias sha='shasum -a 256'
alias yt='youtube-dl --add-metadata -i'
alias yta='yt -x -f bestaudio/best'
alias shut='sudo shutdown -h now'
alias todos="rg 'TODOS:'"

is_in_path()
{
    while [[ $# -gt 0 ]]
    do
        command -v "$1" &>/dev/null || return 1
        shift
    done
}

if [[ $- == *i* ]]
then
    is_in_path exa && alias ls="exa -l --git"
fi

if is_in_path col bat
then
    export MANPAGER='sh -c "col -bx | bat -l man -p"'
else
    export MANPAGER='nvim -c "set ft=man" -'
fi

is_in_path kstart5 && alias restart_plasma='kquitapp5 plasmashell && kstart5 plasmashell' ## %Linux%

if is_in_path visudo
then
    alias visudo="sudo SUDO_EDITOR=$VISUAL visudo"
    alias visudo.d="sudo SUDO_EDITOR=$VISUAL find /etc/sudoers.d -type f -exec visudo -f '{}' ';'"
fi

is_in_path pacman && \
remove_orphans()
{
    local iter packages=()

    while read -r iter
    do
        packages+=("$iter")

    done < <(pacman -Qtdq)

    [[ ${#packages[*]} -gt 0 ]] && sudo pacman -Rns "${packages[@]}"
}

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
    git status --short \
        | sed -En '/^[[:space:]A-Z][AMU]/{s~^[[:space:]]*[A-Z]+[[:space:]]*~~;p;}' \
        | sort | uniq \
        | "$@" | xargs -p "$EDITOR"
}

## Others ##

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

if [[ -n ${BLE_VERSION-} ]]
then
    [[ $USER = 'endorfina' ]] && export PS1="\[\e[0;35m\]🦩\[\e[1;32m\]\$\[\e[0m\] " ## %Linux%

    ble-attach
fi
