#!/bin/sh

ssh-agent -k

eval $(ssh-agent)
export SSH_ASKPASS='/usr/bin/ksshaskpass'
export GIT_ASKPASS='/usr/bin/ksshaskpass'

killall gpg-agent
gpg-connect-agent reloadagent /bye