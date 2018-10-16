#!/bin/bash
#
# 6.2.9 Ensure users own their home directories
#
# Description:
# The user home directory is space defined for the particular user to set local
# environment variables and to store personal files.

set -o errexit
set -o nounset

declare dir=""
declare line=""
declare owner=""
declare status="0"
declare stderr="0"
declare user=""
declare vars=""

while read line; do

    vars=$(
            echo ${line} | \
            egrep -v '^(root|halt|sync|shutdown)' | \
            awk -F: '($7 != "/usr/sbin/nologin" && $7 != "/bin/false") { print $1 " " $6 }'
          ) || status=1

    if [ ${status} = "0" -a "${vars}x" != "x" ]; then
        set -- ${vars}
        user=${1-} && dir=${2-}
        if [ ! -d "$dir" ]; then
            echo "The home directory ($dir) of user ${user} does not exist."
            stderr="1"
        else
            owner=$(stat -L -c "%U" "${dir}") || status=1
            if [ ${status} = "0" ]; then
                if [ "${owner}" != "${user}" ]; then
                    echo "The home directory (${dir}) of user ${user} is owned by ${owner}."
                    stderr="1"
                fi
            fi
        fi
    fi

done < /etc/passwd

if [ ${stderr} != "0" ]; then
    exit 1
fi
