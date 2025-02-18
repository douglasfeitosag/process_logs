#!/bin/bash

rabbitmqadmin -H rabbitmq -P 15672 --username="${RABBITMQ_DEFAULT_USER}" --password="${RABBITMQ_DEFAULT_PASS}" declare exchange name="${RABBITMQ_EXCHANGE}" type=direct

rabbitmqadmin -H rabbitmq -P 15672 --username="${RABBITMQ_DEFAULT_USER}" --password="${RABBITMQ_DEFAULT_PASS}" declare queue name="${RABBITMQ_QUEUE}" durable=true

rabbitmqadmin -H rabbitmq -P 15672 --username="${RABBITMQ_DEFAULT_USER}" --password="${RABBITMQ_DEFAULT_PASS}" declare binding source="${RABBITMQ_EXCHANGE}" destination_type="queue" destination="${RABBITMQ_QUEUE}" routing_key="${RABBITMQ_ROUTING_KEY}"

echo "RabbitMQ setup completed: Exchange=${RABBITMQ_EXCHANGE}, Queue=${RABBITMQ_QUEUE}, RoutingKey=${RABBITMQ_ROUTING_KEY}"
