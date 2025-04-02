FROM curlimages/curl:latest

USER root

RUN apk add --no-cache jq

COPY setup_grafana.sh /setup_grafana.sh

RUN chmod +x /setup_grafana.sh

ENTRYPOINT ["/bin/sh", "/setup_grafana.sh"]
