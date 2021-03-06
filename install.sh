#!/bin/sh

# (ɔ) 2021 endorfina <dev.endorfina@outlook.com>
# WTFPL

readonly PROGNAME=${0##*/}

if test -t 1 -a -t 2
then
    readonly ESC=$(printf '\033')'['
    readonly color_red=$ESC'0;31m'
    readonly color_cyan=$ESC'0;36m'
    readonly color_blue=$ESC'1;34m'
    readonly color_green=$ESC'0;32m'
    readonly color_norm=$ESC'0m'
else
    readonly color_red=
    readonly color_cyan=
    readonly color_blue=
    readonly color_green=
    readonly color_norm=
fi

die()
{
    printf >&2 '💀 %s\n' "${color_red}${PROGNAME} !!${color_norm} $*"
    exit 1
}

show_diff()
{
    if command -v colordiff >/dev/null
    then
        colordiff -w "$1" "$2"

    else
        diff -w "$1" "$2" \
            | sed -E \
            -e "s~^(<.*)$~${color_red}\\1$color_norm~" \
            -e "s~^(>.*)$~${color_green}\\1$color_norm~" \
            -e "s~^([[:digit:]].*)$~${color_cyan}\\1$color_norm~" \
            -e 's~^~ ~'
    fi
}

loud()
{
    printf '+ %s\n' "$*" | \
        sed >&2 -E 's~e[[:space:]]+([s/])[^[:space:]]{3,}([^[:space:]])~e '"$color_green"'\1##\2'"$color_norm"'~g'

    "$@"
}

message()
{
    printf '%s\n' ":$color_blue$*$color_norm" | sed 's~'"'$HOME"'/~'"'"'\~/~'
}

test "$USER" = root && die "This isn't really a sudo kind of business"

cd "$(dirname "$0")" || die "Couldn't move to the root directory"

kernel_name=$(uname -s)
readonly kernel_name

# deletes comments and empty lines
sed -E \
    -e 's~[[:space:]]*#.*$~~' \
    -e '/^[[:space:]]*$/d' \
    -e 's~[[:space:]]\~/~'" $HOME/~" \
    -e 's~[[:space:]]\^/~'" ${XDG_CONFIG_HOME:-$HOME/.config}/~" \
    -e 's~[[:space:]]\!/~'" $HOME/.local/bin/~" \
    "${1:-link_list.txt}" \
    | while read -r line
do
    condition_cmd=$(echo "$line" |\
        sed -nE '/\$/{s~^[^$]*\$[[:space:]]*(if[[:space:]]+)?~~;p;q;}')

    line=$(echo "$line" | sed -E 's~[[:space:]]*\$.*$~~')

    source_file=sources/${line%% *}
    dest_file=${line#* }

    if test -n "$condition_cmd" && ! FILE="$dest_file" sh -c "$condition_cmd"
    then
        message "unavailable '$dest_file'"
        continue
    fi

    if test -f "$dest_file" -a ! "$source_file" -nt "$dest_file"
    then
        message "skipping '$dest_file'"
        continue
    fi

    message "writing to '$dest_file'"

    dest_dirname=${dest_file%/*}

    test -f "$dest_file" \
        && cp "$dest_file" "$dest_file.bak"

    test -d "$dest_dirname" \
        || loud mkdir -p "$dest_dirname"

    loud sed -E \
        -e 's~[[:space:]]*%'"$kernel_name"'%$~~' \
        -e '/%[[:alpha:]]+%$/d' "$source_file" > "$dest_file"

    if test -f "$dest_file.bak"
    then
        show_diff "$dest_file.bak" "$dest_file"
        rm "$dest_file.bak"
    fi

    test -x "$source_file" && loud chmod +x "$dest_file"
done

message 'done'

