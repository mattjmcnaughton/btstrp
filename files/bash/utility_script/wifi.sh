#!/bin/bash
#
# I find it difficult to remember the API for nmcli, so this script wraps
# it into a format that is easier to understand.
#
# A wrapper script around `nmcli` managing wifi from the command line.
#   wifi.sh [COMMAND] [ARGUMENTS]

set -e

# Explicitly set path to be very small.
export PATH=/bin:/usr/bin


PROGRAM=$(basename $0)
SLEEP_CONSTANT=1

# `wifi connect` assumes that we need a password.
wifi::connect() {
    nmcli device wifi connect "$1" password "$2"
}

wifi::on() {
    nmcli radio wifi on
}

wifi::off() {
    nmcli radio wifi off
}

wifi::reconnect() {
    wifi::off
    sleep $SLEEP_CONSTANT
    wifi::on
}

wifi::list() {
    nmcli device wifi list
}

wifi::status() {
    nmcli device status
}

wifi::usage() {
    echo "$PROGRAM [COMMAND] [ARGUMENTS]"
}

case $1 in
connect)
    if [ $# -lt 3 ]
    then
        echo "Must pass \`network\` and \`password\` to \`connect\`" >&2
        exit 2
    fi
    wifi::connect "$2" "$3"
    ;;
on)
    wifi::on
    ;;
off)
    wifi::off
    ;;
list)
    wifi::list
    ;;
reconnect)
    wifi::reconnect
    ;;
status)
    wifi::status
    ;;
help)
    wifi::usage
    ;;
*)
    echo "$PROGRAM $@" >&2
    wifi::usage >& 2
    exit 2
    ;;
esac

exit 0
