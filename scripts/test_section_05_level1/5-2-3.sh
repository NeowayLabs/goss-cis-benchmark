#!/bin/bash
#
# 5.2.3 Ensure permissions on SSH public host key files are configured
# configured (Automated)
#
# Description:
# An SSH public key is one of two files used in SSH public key authentication.
# In this authentication method, a public key is a key that can be used for
# verifying digital signatures generated using a corresponding private key. Only
# a public key that corresponds to a private key will be able to authenticate
# successfully.
#
# Rationale:
# If a public host key file is modified by an unauthorized user, the SSH service
# may be compromised.

set -o errexit
set -o nounset

file=""
files=""
stat_file=""
status="0"
t="0"

files=$(find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub') || status="1"
if [ "${status}" -eq 0 ]; then
  if [ -n "${files}" ]; then
  for file in ${files}; do
      stat_file=$(stat -c "%a-%u-%g-%U-%G" "${file}") || status="1"
        if [ -n "${stat_file}" ]; then
          if [ "${stat_file}" = "600-0-0-root-root" ]; then
              /bin/true
          else
            echo "${file} ownership or permissions is wrong"
            t="1"
          fi
        fi
  done
  fi
  if [ "${t}" -eq 0 ]; then
    echo "Ownership and permissions of public key are correct"
  fi
else
   echo "Ownership and permissions of public key are correct"
fi
