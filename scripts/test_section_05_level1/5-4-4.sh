#!/bin/bash
#
# 5.4.4 Ensure default user umask is 027 or more restrictive (Automated)
#
# Description:
# The user file-creation mode mask ( umask ) is use to determine the file
# permission for newly created directories and files. In Linux, the default
# permissions for any newly created directory is 0777 (rwxrwxrwx), and for any
# newly created file it is 0666 (rw-rw-rw-). The umask modifies the default Linux
# permissions by restricting (masking) these permissions. The umask is not simply
# subtracted, but is processed bitwise. Bits set in the umask are cleared in the
# resulting file mode.
#
# Rationale:
# Setting a very secure default value for umask ensures that users make a
# conscious choice about their file permissions. A default umask setting of 077
# causes files and directories created by users to not be readable by any other
# user on the system. A umask of 027 would make files and directories readable by
# users in the same Unix group, while a umask of 022 would make files readable by
# every user on the system.

set -o errexit
set -o nounset

passing=""

grep --extended-regexp \
  --ignore-case \
  --quiet \
  '^\s*UMASK\s+(0[0-7][2-7]7|[0-7][2-7]7)\b' \
  /etc/login.defs && \
  grep --extended-regexp \
  --quiet \
  '^\s*session\s+(optional|requisite|required)\s+pam_umask\.so\b' \
  /etc/pam.d/common-session \
  && \
  passing="true"

grep --dereference-recursive \
  --extended-regexp \
  --ignore-case \
  --quiet \
  '^\s*UMASK\s+\s*(0[0-7][2-7]7|[0-7][2-7]7|u=(r?|w?|x?)(r?|w?|x?)(r?|w?|x?),g=(r?x?|x?r?),o=)\b' \
  /etc/profile* /etc/bash.bashrc* \
  && \
  passing="true"

[ "$passing" = "true" ] && echo "Default user umask is set"

grep --dereference-recursive \
  --ignore-case \
  --perl-regexp \
  '(^|^[^#]*)\s*umask\s+([0-7][0-7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b|[0-7][01][0-7]\b|[0-7][0-7][0-6]\b|(u=[rwx]{0,3},)?(g=[rwx]{0,3},)?o=[rwx]+\b|(u=[rwx]{1,3},)?g=[^rx]{1,3}(,o=[rwx]{0,3})?\b)' \
  /etc/login.defs \
  /etc/profile* \
  /etc/bash.bashrc*
