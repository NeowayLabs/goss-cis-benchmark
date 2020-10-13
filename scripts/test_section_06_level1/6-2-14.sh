#!/bin/bash
#
# 6.2.14 Ensure no duplicate GIDs exist (Automated)
#
# Description:
# Although the groupadd program will not let you create a duplicate
# Group ID (GID), it is possible for an administrator to manually
# edit the /etc/group file and change the GID field.
#
# Rationale:
# User groups must be assigned unique GIDs for accountability and to ensure
# appropriate access protections.

set -o errexit
set -o nounset

declare groups=""
declare id=""
declare l=""
declare line=""
declare qtd=""
declare status="0"
declare stderr="0"

line=$(cut -f3 -d":" /etc/group | sort -n | uniq -c | awk '{printf $1" "$2"@"}' |sed 's#@$##g') || status=1

if [ ${status} = "0" ]; then

    IFS="@"
    for l in ${line}; do
            IFS=" " && set - ${l}
            qtd=${1-} && id=${2-}
            if [ ${qtd} -gt 1 ]; then
               groups=$(awk -F: '($3 == n) { print $1 }' n=${id} /etc/group | xargs)
               echo "Duplicate GID (${id}): ${groups}"
               stderr="1"
            fi
    done

fi

if [ ${stderr} != "0" ]; then
    exit 1
fi
