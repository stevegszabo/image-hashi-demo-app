FROM ubuntu:latest

LABEL maintainer "Cody De Arkland <cdearkland@vmware.com>"
LABEL description "Python API tier running flask, gunicorn, and supervisord"

COPY requirements.txt /tmp/requirements.txt

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y python3 \
    postgresql-dev \
    gcc \ 
    g++ \
    make \
    libffi-dev \
    python3-dev \ 
    musl-dev \
    git \
    linux-headers && \
    apt-get clean

RUN python3 -m ensurepip && \
    pip3 install --upgrade pip setuptools && \
    pip3 install -r /tmp/requirements.txt

COPY ./app /app
COPY app.conf /usr/supervisord.conf

CMD ["/app/entrypoint.sh"]
