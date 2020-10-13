#!/bin/bash
#
# 6.2.7 Ensure users' dot files are not group or world writable (Automated)
#
# Description:
# While the system administrator can establish secure permissions for users'
# "dot" files, the users can easily override these.
#
# Group or world-writable user configuration files may enable malicious users to
# steal or modify other users' data or to gain another user's system privileges.

set -o errexit
set -o nounset

declare dir=""
declare file=""
declare fileperm=""
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
            echo "The home directory (${dir}) of user ${user} does not exist."
            stderr="1"
        else
            for file in ${dir}/.[A-Za-z0-9]*; do
                if [ ! -h "${file}" -a -f "${file}" ]; then
                    fileperm=`ls -ld ${file} | cut -f1 -d" "`
                    if [ $(echo ${fileperm} | cut -c6) != "-" ]; then
                        echo "Group Write permission set on file ${file}"
                        stderr="1"
                    fi
                    if [ $(echo ${fileperm} | cut -c9)  != "-" ]; then
                        echo "Other Write permission set on file ${file}"
                        stderr="1"
                    fi
                fi
            done
        fi
    fi

done < /etc/passwd

if [ ${stderr} != "0" ]; then
   exit 1
fi
