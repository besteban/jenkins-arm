FROM openjdk:8u151-jdk-alpine3.7

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