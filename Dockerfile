FROM alpine:20200626

ENV BUILD_DEPS autoconf make g++ gcc groff less py-pip

RUN \
    # Upgrade
    apk upgrade --no-cache && \
    #
    # Required deps
    apk add --upgrade --no-cache bash inotify-tools wget curl python3 jq nano && \
    #
    # Build deps
    apk add --no-cache --virtual .build-deps $BUILD_DEPS && \
    #
    # AWS CLI
    pip install awscli && \
    #
    # Remove build deps
    rm -rf /var/cache/apk/* && \
    apk del --purge .build-deps
