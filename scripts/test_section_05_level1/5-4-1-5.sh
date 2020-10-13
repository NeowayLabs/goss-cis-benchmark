#!/bin/bash
#
# 5.4.1.5 Ensure all users last password change date is in the past (Automated)
#
# Description:
# All users should have a password change date in the past.
#
# Rationale:
# If a users recorded password change date is in the future then they could
# bypass any set password expiration.

set -o errexit
set -o nounset

for usr in $(cut -d: -f1 /etc/shadow); do
  [[ \
    $(chage --list $usr | grep '^Last password change' | cut -d: -f2) > $(date)
  ]] \
    && \
    echo "$usr :$(chage --list $usr | grep '^Last password change' | cut -d: -f2)";
done
