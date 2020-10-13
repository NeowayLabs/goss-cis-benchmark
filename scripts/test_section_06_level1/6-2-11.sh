#!/bin/bash
#
# 6.2.11 Ensure no users have .rhosts files (Automated)
#
# Description:
# While no .rhosts files are shipped by default, users can easily create them.
#
# Rationale:
# This action is only meaningful if .rhosts support is permitted in the file
# /etc/pam.conf. Even though the .rhosts files are ineffective if support is
# disabled in /etc/pam.conf , they may have been brought over from other systems
# and could contain information useful to an attacker for those other systems.

set -o errexit
set -o nounset

declare dir=""
declare file=""
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
            for file in ${dir}/.rhosts; do
                if [ ! -h "${file}" -a -f "${file}" ]; then
                    echo ".rhosts file in ${dir}"
                    stderr="1"
                fi
            done
        fi
    fi

done < /etc/passwd

if [ ${stderr} != "0" ]; then
    exit 1
fi
