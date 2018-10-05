#!/bin/bash

set -o errexit
set -o nounset

declare dirown=""
declare dirperm=""
declare p=""
declare path=""
declare status="0"

echo ${PATH} | grep "::" > /dev/null 2>&1 && status=1

if [ ${status} != "0" ]; then
   echo "Empty Directory in PATH (::)"
   exit 1
fi

echo $PATH | grep ":$" > /dev/null 2>&1 && status=1

if [ ${status} != "0" ]; then
 echo "Trailing : in PATH"
 exit 1
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
            echo "Group Write permission set on directory ${p}" fi
            exit 1
        fi
        echo ${dirperm} | cut -c9 | grep "-" > /dev/null 2>&1 || status=1
        if [ ${status} != "0" ]; then
            echo "Other Write permission set on directory ${p}"
            exit 1
        fi
        dirown=$(ls -ldH ${p} | awk '{print $3}') || status=1
        if [ ${status} = "0" ]; then
            if [ "${dirown}" != "root" ] ; then
                echo "${p} is not owned by root"
                exit 1
            fi
        fi
    else
        echo "${p} is not a directory"
        exit 1
    fi
    shift
done
