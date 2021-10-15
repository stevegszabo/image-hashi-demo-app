#!/bin/bash

PROFILE=/app/profile.sh

[ -f $PROFILE ] && source $PROFILE

/usr/bin/supervisord --nodaemon -c /usr/supervisord.conf

exit $?
