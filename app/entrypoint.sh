#!/bin/bash

PROFILE=/vault/secrets/webapp

[ -f $PROFILE ] && source $PROFILE

/usr/bin/supervisord --nodaemon -c /usr/supervisord.conf

exit $?
