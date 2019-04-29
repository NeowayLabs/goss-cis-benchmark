#!/bin/bash
#
# 6.1.14 Audit SGID executables (Not Scored)
#
# Description:
# The owner of a file can set the file's permissions to run with the owner's or group's permissions,
# even if the user running the program is not the owner or a member of the group.
# The most common reason for a SGID program is to enable users to perform functions (such as changing their password) that require root privileges.

set -o errexit
set -o nounset

declare gcp_binaries="24"
declare azure_binaries="8"
declare url_google="http://metadata/computeMetadata/v1/instance/hostname"
status=0

count_SGID=$(df --local -P | awk "{'if (NR!=1) print $6'}" | xargs -I '{}' find '{}' -xdev -type f -perm -2000 | wc -l)

curl -v -H Metadata-Flavor:Google $url_google -f > /dev/null 2>&1 || status=1

if [[ "${status}x" == "0x" ]]; then
  if [[ $count_SGID == "$gcp_binaries" ]]; then
    exit 0
  else
    exit 1
  fi
fi

if [[ $count_SGID == "$azure_binaries" ]]; then
  exit 0
else
  exit 1
fi
