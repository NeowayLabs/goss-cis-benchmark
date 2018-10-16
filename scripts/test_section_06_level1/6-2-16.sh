#!/bin/bash
#
# 6.2.16 Ensure no duplicate UIDs exist
#
# Description:
# Although the useradd program will not let you create a duplicate
# User ID (UID), it is possible for an administrator to manually edit
# the /etc/passwd file and change the UID field.

set -o errexit
set -o nounset

declare id=""
declare l=""
declare line=""
declare qtd=""
declare status="0"
declare stderr="0"
declare users=""

line=$(cut -f3 -d":" /etc/passwd | sort -n | uniq -c | awk '{printf $1" "$2"@"}' |sed 's#@$##g') || status=1

if [ ${status} = "0" ]; then

    IFS="@"
    for l in ${line}; do
            IFS=" " && set - ${l}
            qtd=${1-} && id=${2-}
            if [ ${qtd} -gt 1 ]; then
               users=$(awk -F: '($3 == n) { print $1 }' n=${id} /etc/passwd | xargs)
               echo "Duplicate UID (${id}): ${users}"
               stderr="1"
            fi
    done

fi

if [ ${stderr} != "0" ]; then
    exit 1
fi
