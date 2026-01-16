FROM alpine:3.23.2

RUN \
    # Upgrade
    apk upgrade --no-cache && \
    #
    # Required deps
    apk add --upgrade --no-cache bash inotify-tools wget curl python3 jq nano less groff py-pip xz aws-cli aws-cli-bash-completion && \
    #
    # Cleanup
    rm -rf /var/cache/apk/*
