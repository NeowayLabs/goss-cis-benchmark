#!/bin/bash
#
# 6.2.13 Ensure users' .netrc Files are not group or world accessible
#
# Description:
# While the system administrator can establish secure permissions for users'
# .netrc files, the users can easily override these.

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
        if [ ! -d ${dir} ]; then
            echo "The home directory (${dir}) of user ${user} does not exist."
            stderr="1"
        else
            for file in ${dir}/.netrc; do
                if [ ! -h "${file}" -a -f "${file}" ]; then
                    fileperm=$(ls -ld ${file} | cut -f1 -d" ")
                    if [ $(echo ${fileperm} | cut -c5)  != "-" ]; then
                        echo "Group Read set on ${file}"
                        stderr="1"
                    fi
                    if [ $(echo ${fileperm} | cut -c6)  != "-" ]; then
                        echo "Group Write set on ${file}"
                        stderr="1"
                    fi
                    if [ $(echo ${fileperm} | cut -c7)  != "-" ]; then
                        echo "Group Execute set on ${file}"
                        stderr="1"
                    fi
                    if [ $(echo ${fileperm} | cut -c8)  != "-" ]; then
                        echo "Other Read set on ${file}"
                        stderr="1"
                    fi
                    if [ $(echo ${fileperm} | cut -c9)  != "-" ]; then
                        echo "Other Write set on ${file}"
                        stderr="1"
                    fi
                    if [ $(echo ${fileperm} | cut -c10)  != "-" ]; then
                        echo "Other Execute set on ${file}"
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
