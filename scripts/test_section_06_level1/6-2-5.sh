#!/bin/bash
#
# 6.2.5 Ensure users' home directories permissions are 750 or more restrictive (Automated)
#
# Description:
# While the system administrator can establish secure permissions
# for users' home directories, the users can easily override these.
#
# Rationale:
# Group or world-writable user home directories may enable malicious users to
# steal or modify other users' data or to gain another user's system privileges.

set -o errexit
set -o nounset

declare dir=""
declare dirperm=""
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
            dirperm=$(ls -ld $dir | cut -f1 -d" ") || status=1
            if [ ${status} = "0" ]; then
                if [ $(echo ${dirperm} | cut -c6) != "-" ]; then
                    echo "Group Write permission set on the home directory (${dir}) of user ${user}"
                    stderr="1"
                fi
                if [ $(echo ${dirperm} | cut -c8) != "-" ]; then
                    echo "Other Read permission set on the home directory (${dir}) of user ${user}"
                    stderr="1"
                fi
                if [ $(echo ${dirperm} | cut -c9) != "-" ]; then
                    echo "Other Write permission set on the home directory (${dir}) of user ${user}"
                    stderr="1"
                fi
                if [ $(echo ${dirperm} | cut -c10) != "-" ]; then
                    echo "Other Execute permission set on the home directory (${dir}) of user ${user}"
                    stderr="1"
                fi
            fi
        fi
    fi

done < /etc/passwd

if [ ${stderr} != "0" ]; then
    exit 1
fi
