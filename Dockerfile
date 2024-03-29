FROM ubuntu:20.04

LABEL maintainer "Cody De Arkland <cdearkland@vmware.com>"
LABEL description "Python API tier running flask and gunicorn"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y python3 \
    python3-pip \
    python3-postgresql \
    postgresql-client \
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

COPY app /app
COPY requirements.txt /tmp/requirements.txt

RUN pip3 install --upgrade pip setuptools && \
    pip3 install -r /tmp/requirements.txt && \
    rm -f /tmp/requirements.txt

RUN chown -R www-data:www-data /app
USER www-data
ENTRYPOINT ["/app/entrypoint.sh"]
