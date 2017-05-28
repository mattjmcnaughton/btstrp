#!/bin/bash

# Install the dependencies necessary for running
# the main `playbook.yml` which configures the
# machine.
# Currently this only supports Linux systems with
# `apt` installed.

set -e

KERNEL=`uname -a | cut -d " " -f1`

if [ "$KERNEL" = "Linux" ]
then
    if which apt
    then
        sudo apt-get install software-properties-common
        sudo apt-add-repository ppa:ansible/ansible
        sudo apt-get update
        sudo apt-get install ansible

        mkdir roles
        ansible-galaxy install -r requirements.yml
    else
        exit 1
    fi
elif [ "$KENEL" = "Darwin" ]
then
    exit 1
else
    exit 1
fi

