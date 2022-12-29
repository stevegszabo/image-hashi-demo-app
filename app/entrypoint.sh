#!/bin/bash

PROFILE=/vault/secrets/config

if [ -f $PROFILE ]; then
    source $PROFILE
else
    POSTGRES_USER=postgres
    POSTGRES_PASSWORD=mydbpass
    export POSTGRES_USER POSTGRES_PASSWORD
fi

###/usr/bin/supervisord --nodaemon -c /usr/supervisord.conf
gunicorn --worker-class eventlet -w 1 main:app -b 0.0.0.0:5000

exit $?
