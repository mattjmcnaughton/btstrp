#! /bin/bash
# Configure any connected mouse devices with decreased acceleration
# and natural scrolling.
#
# Usage:
#     xinput_configuration.sh

# Currently this only works with my `Anker` mouse. Update to use a more
# generic mapping between settings amd values for different types of mouses.

set -e

export PATH=/bin:/usr/bin

PROGRAM=$(basename $0)

xinput_configuration::mouse_settings() {
    while [ $# -gt 0 ]
    do
        accel_setting="Device Accel Constant Deceleration"
        accel_value="2.0"
        if xinput --list-props "$1" | grep -q "$accel_setting"
        then
            xinput --set-prop "$1" "$accel_setting" $accel_value
        fi

        scrolling_setting="Evdev Scrolling Distance"
        scrolling_value="-1, -1, -1"
        if xinput --list-props "$1" | grep -q "$scrolling_setting"
        then
            xinput --set-prop "$1" "$scrolling_setting" $scrolling_value
        fi

        shift
    done
}

# Must export the function so we can use it with `bash -c`.
export -f xinput_configuration::mouse_settings

xinput_configuration::run() {
    xinput --list |
        grep -E ".*slave.*pointer.*" |
            tr -cd '[:alnum:][:punct:][:space:]' |
                sed -e 's/\s\+/ /g' -e 's/^\s//g' |
                    grep -Eo ".*id=" |
                        sed -e 's/\s\+id=//g' |
                            xargs -d '\n' bash -c 'xinput_configuration::mouse_settings "$@"' "$0"
}

xinput_configuration::usage() {
    echo "$PROGRAM"
}

if [ $# -eq 0 ]
then
    xinput_configuration::run
else
    if [ $1 = "help" ]
    then
        xinput_configuration::usage
    else
        echo "$PROGRAM $@" >&2
        xinput_configuration::usage >& 2
        exit 2
    fi
fi

exit 0
