FROM alpine:3.12

WORKDIR /foo

COPY foo/bar .
RUN ls -la
RUN md5sum *

CMD [ "sh", "-c", "while true; do echo '****'; ls -la; md5sum *; cat bar; sleep 1; done" ]
