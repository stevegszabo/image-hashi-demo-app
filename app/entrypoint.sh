#!/bin/bash

PROFILE=/vault/secrets/config

if [ -f $PROFILE ]; then
    source $PROFILE
else
    POSTGRES_USER=postgres
    POSTGRES_PASSWORD=mydbpass
    export POSTGRES_USER POSTGRES_PASSWORD
fi

gunicorn app.main:app --worker-class=eventlet --workers=1 --bind=0.0.0.0:5000 --log-level=debug --access-logfile=- --error-logfile=-

exit $?
