#!/bin/bash
#
# 6.2.15 Ensure no duplicate user names exist (Automated)
#
# Description:
# Although the useradd program will not let you create a duplicate user name, it
# is possible for an administrator to manually edit the /etc/passwd file and
# change the user name.
#
# Rationale:
# If a user is assigned a duplicate user name, it will create and have access to
# files with the first UID for that username in /etc/passwd . For example, if
# "test4" has a UID of 1000 and a subsequent "test4" entry has a UID of 2000,
# logging in as "test4" will use UID 1000. Effectively, the UID is shared, which
# is a security problem.

set -o errexit
set -o nounset

declare l=""
declare line=""
declare qtd=""
declare status="0"
declare stderr="0"
declare uids=""
declare user=""

line=$(cut -f1 -d":" /etc/passwd | sort -n | uniq -c | awk '{printf $1" "$2"@"}' |sed 's#@$##g') || status=1

if [ ${status} = "0" ]; then

    IFS="@"
    for l in ${line}; do
            IFS=" " && set - ${l}
            qtd=${1-} && user=${2-}
            if [ ${qtd} -gt 1 ]; then
                uids=$(awk -F: '($1 == n) { print $3 }' n=${user} /etc/passwd | xargs)
                echo "Duplicate User Name (${user}): ${uids}"
                stderr="1"
            fi
    done

fi

if [ ${stderr} != "0" ]; then
    exit 1
fi
