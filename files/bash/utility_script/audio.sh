#!/bin/bash
#
# A wrapper around volume management. This script makes it simple to control the
# sound from the command line.
#   audio.sh [COMMAND] [ARGUMENTS]

set -e

# Explicitly set path to be restrictively small.
export PATH=/bin:/usr/bin

AMIXER_BASE="amixer -D pulse"
AMIXER_SET="$AMIXER_BASE sset Master"
DEFAULT_INCREMENT=5
PROGRAM=$(basename $0)

audio::mute() {
    bash -c "$AMIXER_SET 0\% mute"
}

audio::unmute() {
    bash -c "$AMIXER_SET 0\% unmute"
}

audio::up() {
    bash -c "$AMIXER_SET $1\%+"
}

audio::down() {
    bash -c "$AMIXER_SET $1\%-"
}

audio::status() {
    bash -c "$AMIXER_BASE get Master"
}

audio::usage() {
    echo "$PROGRAM [COMMAND] [ARGUMENTS]"
}

case $1 in
mute)
    audio::mute
    ;;
unmute)
    audio::unmute
    ;;
up)
    if [ $# -eq 2 ]
    then
        audio::up "$2"
    else
        audio::up "$DEFAULT_INCREMENT"
    fi
    ;;
down)
    if [ $# -eq 2 ]
    then
        audio::down "$2"
    else
        audio::down "$DEFAULT_INCREMENT"
    fi
    ;;
status)
    audio::status
    ;;
help)
    audio::usage
    ;;
*)
    echo "$PROGRAM $@" >&2
    audio::usage >& 2
    exit 2
    ;;
esac

exit 0
