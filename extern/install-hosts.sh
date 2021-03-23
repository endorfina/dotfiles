#!/bin/sh

# (ɔ) 2021 endorfina <dev.endorfina@outlook.com>
# WTFPL

readonly PROGNAME=${0##*/}

if test -t 1 -a -t 2
then
    readonly ESC=$(printf '\033')'['
    readonly color_red=$ESC'0;31m'
    readonly color_green=$ESC'0;32m'
    readonly color_norm=$ESC'0m'
else
    readonly color_red=
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
    printf '%s\n' "💻 $color_green$*$color_norm" >&2
    "$@"
}

load_library()
{
    test -e "$1" || loud git submodule update --init --recursive --depth 1 hosts
}

test "$USER" = root && die "This isn't really a sudo kind of business"

cd "$(dirname "$0")" || die "Couldn't move to the root directory"

# shellcheck disable=SC2015
load_library hosts/* \
    && loud sudo cp hosts/alternates/fakenews-gambling-porn/hosts /etc/hosts \
    || die "Install failure"

