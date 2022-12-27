FROM alpine:latest

LABEL maintainer "Cody De Arkland <cdearkland@vmware.com>"
LABEL description "Python API tier running flask, gunicorn, and supervisord"

COPY requirements.txt /tmp/requirements.txt

RUN apk add --no-cache \
    python3 \
    bash \
    postgresql-dev \
    gcc \ 
    g++ \
    file \
    make \
    libffi-dev \
    python3-dev \ 
    musl-dev \
    git \
    linux-headers

RUN python3 -m ensurepip && \
    pip3 install --upgrade pip setuptools && \
    pip3 install https://github.com/eventlet/eventlet/archive/master.zip && \
    pip3 install -r /tmp/requirements.txt

COPY ./app /app
COPY app.conf /usr/supervisord.conf

CMD ["/app/entrypoint.sh"]
