FROM alpine:3

RUN apk add bash curl jq

COPY ./scripts /scripts
RUN /scripts/downloadDocker.sh

ENTRYPOINT ["/bin/bash"]
CMD ["/scripts/dockerPsResponseTime.sh"]
