#!/bin/bash

PROFILE=/vault/secrets/config

if [ -f $PROFILE ]; then
    source $PROFILE
else
    POSTGRES_USER=postgres
    POSTGRES_PASSWORD=mydbpass
    export POSTGRES_USER POSTGRES_PASSWORD
fi

/usr/bin/supervisord --nodaemon -c /usr/supervisord.conf

exit $?
