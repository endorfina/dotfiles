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
    printf >&2 '💀 %s\n' "$color_red$PROGNAME !!$color_norm $*"
    exit 1
}

loud()
{
    printf "+ $color_cyan%s$color_norm\n" "$*"
    "$@"
}

test "$USER" = root && die "This isn't really a sudo kind of business"

cd "$(dirname "$0")" || die "Couldn't move to the root directory"

(set -- ble.sh/* ; test -e "$1" \
    || loud git submodule update --init --recursive --depth 1 ble.sh) \
    && loud make -C ble.sh install PREFIX=~/.local

