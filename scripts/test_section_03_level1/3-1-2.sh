#!/bin/bash
#
# 3.1.2 Ensure wireless interfaces are disabled (Automated)
#
# Description:
# Wireless networking is used when wired networks are unavailable. Ubuntu
# contains a wireless tool kit to allow system administrators to configure
# and use wireless networks.
#
# Rationale:
# If wireless is not to be used, wireless devices can be disabled to reduce
# the potential attack surface.

set -o errexit
set -o nounset

dm=""
driverdir=""
drivers=""
status="0"
t="0"

command -v nmcli >/dev/null 2>&1 || status="1"

if [[ "${status}" -eq 0 ]]; then
  nmcli radio all | grep -Eq '\s*\S+\s+disabled\s+\S+\s+disabled\b' || status="1"
  if [[ "${status}" -eq 1 ]]; then
    echo "Wireless is not enabled"
  fi
elif [[ -n "$(find /sys/class/net/*/ -type d -name wireless)" ]]; then
  drivers=$(for driverdir in $(find /sys/class/net/*/ -type d -name wireless | xargs -0 dirname); do basename "$(readlink -f "${driverdir}"/device/driver)"; done | sort -u)
  for dm in ${drivers}; do
    if grep -Eq "^\s*install\s+${dm}\s+/bin/(true|false)" /etc/modprobe.d/*.conf; then
      /bin/true
    else
      echo "${dm} is not disabled"
      t="1"
    fi
  done
  if [[ "${t}" -eq 0 ]]; then
    echo "Wireless is not enabled"
  fi
else
   echo "Wireless is not enabled"
fi
