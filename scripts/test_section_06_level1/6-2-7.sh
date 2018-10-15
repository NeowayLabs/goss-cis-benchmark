#!/bin/bash
#
# 6.2.7 Ensure all users' home directories exist
#
# Description:
# Users can be defined in /etc/passwd without a home directory or with a home
# directory that does not actually exist.

set -o errexit
set -o nounset

declare dir=""
declare line=""
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
        fi
    fi

done < /etc/passwd

if [ ${stderr} != "0" ]; then
    exit 1
fi
