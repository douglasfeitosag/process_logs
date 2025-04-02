FROM rabbitmq:3.13-management

USER root

RUN apt-get update && apt-get install -y gettext-base

COPY rabbitmq.conf /etc/rabbitmq/rabbitmq.conf
COPY definitions.template.json /etc/rabbitmq/definitions.template.json
COPY docker_entrypoint.sh /docker_entrypoint.sh
COPY .erlang.cookie /var/lib/rabbitmq/.erlang.cookie

RUN chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
RUN chmod 400 /var/lib/rabbitmq/.erlang.cookie
RUN chmod +x /docker_entrypoint.sh

USER rabbitmq

ENTRYPOINT ["/docker_entrypoint.sh"]
