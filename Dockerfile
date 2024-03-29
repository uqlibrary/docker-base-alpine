ARG ALPINE_VERSION=3.18.4
FROM python:3.10-alpine3.18 as builder

ARG AWS_CLI_VERSION=2.13.25
RUN apk add --no-cache git unzip groff build-base libffi-dev cmake
RUN git clone --single-branch --depth 1 -b ${AWS_CLI_VERSION} https://github.com/aws/aws-cli.git

WORKDIR aws-cli
RUN python -m venv venv
RUN . venv/bin/activate
RUN scripts/installers/make-exe
RUN unzip -q dist/awscli-exe.zip
RUN aws/install --bin-dir /aws-cli-bin
RUN /aws-cli-bin/aws --version

# reduce image size: remove autocomplete and examples
#RUN rm -rf \
#    /usr/local/aws-cli/v2/current/dist/aws_completer \
#    /usr/local/aws-cli/v2/current/dist/awscli/data/ac.index \
#    /usr/local/aws-cli/v2/current/dist/awscli/examples
#RUN find /usr/local/aws-cli/v2/current/dist/awscli/data -name completions-1*.json -delete
#RUN find /usr/local/aws-cli/v2/current/dist/awscli/botocore/data -name examples-1.json -delete

# build the final image
FROM alpine:${ALPINE_VERSION}
COPY --from=builder /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=builder /aws-cli-bin/ /usr/local/bin/

RUN \
    # Upgrade
    apk upgrade --no-cache && \
    #
    # Required deps
    apk add --upgrade --no-cache bash inotify-tools wget curl python3 jq nano less groff py-pip xz && \
    #
    # Cleanup
    rm -rf /var/cache/apk/*
