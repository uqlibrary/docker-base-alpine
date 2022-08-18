FROM alpine:3.15.6

ENV BUILD_DEPS autoconf make g++ gcc

RUN \
    # Upgrade
    apk upgrade --no-cache && \
    #
    # Required deps
    apk add --upgrade --no-cache bash inotify-tools wget curl python3 jq nano less groff py-pip xz && \
    #
    # Build deps
    apk add --no-cache --virtual .build-deps $BUILD_DEPS && \
    #
    # AWS CLI
    pip install awscli && \
    aws --version && \
    #
    # Remove build deps
    rm -rf /var/cache/apk/* && \
    apk del --purge .build-deps
