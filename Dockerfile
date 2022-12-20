FROM alpine:3.16
RUN apk add --no-cache openssh unison

ENV UNISONLOCALHOSTNAME=unison

ENTRYPOINT ["unison"]
