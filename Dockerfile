FROM ubuntu:20.04

LABEL maintainer "Cody De Arkland <cdearkland@vmware.com>"
LABEL description "Python API tier running flask, gunicorn, and supervisord"

COPY requirements.txt /tmp/requirements.txt

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y python3 \
    python3-pip \
    python3-postgresql \
    postgresql-client \
    supervisor \
    git \
    gcc \ 
    g++ \
    make \
    libpq-dev \
    libffi-dev \
    python3-dev \ 
    musl-dev \
    linux-generic && \
    apt-get clean

RUN pip3 install --upgrade pip setuptools && \
    pip3 install -r /tmp/requirements.txt

COPY app/ /app
COPY app.conf /usr/supervisord.conf

CMD ["/app/entrypoint.sh"]
