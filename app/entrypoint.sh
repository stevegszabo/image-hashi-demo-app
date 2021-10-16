#!/bin/bash

PROFILE=/vault/secrets/config

[ -f $PROFILE ] && source $PROFILE

/usr/bin/supervisord --nodaemon -c /usr/supervisord.conf

exit $?
