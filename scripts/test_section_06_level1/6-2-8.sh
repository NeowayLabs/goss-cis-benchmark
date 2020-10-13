#!/bin/bash
#
# 6.2.8 Ensure no users have .forward files (Automated)
#
# Description:
# The .forward file specifies an email address to forward the user's mail to.
#
# Rationale:
# Use of the .forward file poses a security risk in that sensitive data may be
# inadvertently transferred outside the organization. The .forward file also
# poses a risk as it can be used to execute commands that may perform unintended
# actions.

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
        if [ ! -d ${dir} ]; then
            echo "The home directory (${dir}) of user ${user} does not exist."
            stderr="1"
        else
            if [ ! -h "${dir}/.forward" -a -f "${dir}/.forward" ]; then
                echo ".forward file ${dir}/.forward exists"
                stderr="1"
            fi
        fi
    fi

done < /etc/passwd

if [ ${stderr} != "0" ]; then
    exit 1
fi
