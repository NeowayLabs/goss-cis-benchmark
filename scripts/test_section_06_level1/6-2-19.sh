#!/bin/bash
#
# 6.2.19 Ensure no duplicate group names exist
#
# Description:
# Although the groupadd program will not let you create a duplicate
# group name, it is possible for an administrator to manually edit
# the /etc/group file and change the group name.

set -o errexit
set -o nounset

declare gids=""
declare group=""
declare l=""
declare line=""
declare qtd=""
declare status="0"
declare stderr="0"

line=$(cut -f1 -d":" /etc/group | sort -n | uniq -c | awk '{printf $1" "$2"@"}' |sed 's#@$##g') || status=1

if [ ${status} = "0" ]; then

    IFS="@"
    for l in ${line}; do
            IFS=" " && set - ${l}
            qtd=${1-} && group=${2-}
            if [ ${qtd} -gt 1 ]; then
                gids=$(awk -F: '($1 == n) { print $3 }' n=${group} /etc/group | xargs)
                echo "Duplicate Group Name (${group}): ${gids}"
                stderr="1"
            fi
    done

fi

if [ ${stderr} != "0" ]; then
    exit 1
fi
