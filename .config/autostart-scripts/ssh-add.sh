#!/bin/sh

try=0

while [ ! -S "${PAM_KWALLET5_LOGIN}" ]; do
    [ $try -e 10 ] && exit
    sleep 1
    try=$(($try+1))
done

DOTSSHDIR="${HOME}/.ssh"

for FILE in $(ls "${DOTSSHDIR}/${FILE}"); do
    FPATH=$(readlink -f "${DOTSSHDIR}/${FILE}")
    file "${FPATH}" | egrep -q 'private key$' && ssh-add "${FPATH}" </dev/null
done