FROM alpine:3.16
RUN apk add --no-cache openssh unison && \
	adduser -D unison && \
	mkdir /home/unison/.unison && \
	chown -R unison:unison /home/unison

ENV UNISONLOCALHOSTNAME=unison

USER unison
ENTRYPOINT ["unison"]
