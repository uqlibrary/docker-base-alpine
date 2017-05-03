FROM alpine:edge

ENV BUILD_DEPS autoconf make g++ gcc groff less py-pip

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    # Required deps
    && apk add --update bash wget curl python jq \

    # Build deps
    && apk add --no-cache --virtual .build-deps $BUILD_DEPS \

    # AWS CLI
    && pip install awscli \

    # Remove build deps
    && rm -rf /var/cache/apk/* \
    && apk --purge del .build-deps
