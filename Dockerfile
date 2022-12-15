FROM alpine:3.16
RUN apk add --no-cache openssh unison && \
        adduser -D unison && \
        mkdir -p /home/unison/.unison && \
        mkdir -p /home/unison/.ssh && \
        mkdir -p /home/unison/log && \
        chown -R unison:unison /home/unison /home/unison/.ssh /home/unison/log

ENV UNISONLOCALHOSTNAME=unison

USER unison
WORKDIR /home/unison
ENTRYPOINT ["unison"]
