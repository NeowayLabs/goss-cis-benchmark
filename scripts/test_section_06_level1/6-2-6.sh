#!/bin/bash
#
# 6.2.6 Ensure root PATH Integrity
#
# Description:
# The root user can execute any command on the system and could be fooled into executing
# programs unintentionally if the PATH is not set correctly.

set -o errexit
set -o nounset

declare dirown=""
declare dirperm=""
declare p=""
declare path=""
declare status="0"
declare stderr="0"

echo ${PATH} | grep "::" > /dev/null 2>&1 && status=1

if [ ${status} != "0" ]; then
   echo "Empty Directory in PATH (::)"
   stderr="1"
fi

echo $PATH | grep ":$" > /dev/null 2>&1 && status=1

if [ ${status} != "0" ]; then
    echo "Trailing : in PATH"
    stderr="1"
fi

path=$(echo ${PATH} | sed -e 's/::/:/' -e 's/:$//' -e 's/:/ /g')
set -- ${path}
while [ "${1-}" != "" ]; do
    p=${1-}
    if [ "${p}" = "." ]; then
        echo "PATH contains ."
        shift
        continue
    fi
    if [ -d "${p}" ]; then
        dirperm=$(ls -ldH ${p} | cut -f1 -d" ")
        echo ${dirperm} | cut -c6 | grep "-" > /dev/null 2>&1 || status=1
        if [ ${status} != "0" ]; then
            echo "Group Write permission set on directory ${p}"
            stderr="1"
        fi
        echo ${dirperm} | cut -c9 | grep "-" > /dev/null 2>&1 || status=1
        if [ ${status} != "0" ]; then
            echo "Other Write permission set on directory ${p}"
            stderr="1"
        fi
        dirown=$(ls -ldH ${p} | awk '{print $3}') || status=1
        if [ ${status} = "0" ]; then
            if [ "${dirown}" != "root" ] ; then
                echo "${p} is not owned by root"
                stderr="1"
            fi
        fi
    else
        echo "${p} is not a directory"
        stderr="1"
    fi
    shift
done

if [ ${stderr} != "0" ]; then
    exit 1
fi
