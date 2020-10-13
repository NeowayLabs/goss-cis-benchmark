#!/bin/bash
#
# 5.2.2 Ensure permissions on SSH private host key files are
# configured (Automated)
#
# Description:
# An SSH private key is one of two files used in SSH public key authentication.
# In this authentication method, The possession of the private key is proof of
# identity. Only a private key that corresponds to a public key will be able to
# authenticate successfully. The private keys need to be stored and handled
# carefully, and no copies of the private key should be distributed.
#
# Rationale:
# If an unauthorized user obtains the private SSH host key file, the host could
# be impersonated

set -o errexit
set -o nounset

file=""
files=""
stat_file=""
status="0"
t="0"

files=$(find /etc/ssh -xdev -type f -name 'ssh_host_*_key') || status="1"
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
    echo "Ownership and permissions of private key are correct"
  fi
else
   echo "Ownership and permissions of private key are correct"
fi
