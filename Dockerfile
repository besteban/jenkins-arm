FROM alpine:latest

RUN apk update
RUN apk add \
    gnupg \
    tar \
    ruby \
    git \
    zip \
    curl \
    wget \
    && rm -rf /var/cache/apk/*