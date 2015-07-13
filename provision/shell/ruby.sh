#!/usr/bin/env bash

PROGRAM="ruby"
PACKAGE="ruby"

$(which ruby > /dev/null 2>&1)

FOUND=$?

if [ "$FOUND" -ne '0' ]; then
  echo "Attempting to install  ${PROGRAM} ."
  $(which apt-get > /dev/null 2>&1)
  FOUND_APT=$?
  $(which yum > /dev/null 2>&1)
  FOUND_YUM=$?
 
  if [ "${FOUND_YUM}" -eq '0' ]; then
    yum -q -y makecache
    yum -q -y install "${PACKAGE}"
    echo 'git installed.'
  elif [ "${FOUND_APT}" -eq '0' ]; then
    apt-get -q -y update
    apt-get -q -y install "${PACKAGE}"
    echo '${PROGRAM} installed.'
  else
    echo 'No package installer available. You may need to install ${PACKAGE} manually.'
  fi
else
  echo '${PROGRAM} found.'
fi
