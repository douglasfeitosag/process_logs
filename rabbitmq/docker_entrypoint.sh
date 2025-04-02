#!/bin/bash
set -e

echo "Generating RabbitMQ configuration from environment variables..."

HASHED_PASSWORD=$(rabbitmqctl hash_password "$RABBITMQ_DEFAULT_PASS" | tail -n 1)

export RABBITMQ_HASHED_PASS="$HASHED_PASSWORD"

envsubst < /etc/rabbitmq/definitions.template.json > /etc/rabbitmq/definitions.json

echo "Starting RabbitMQ..."
exec rabbitmq-server
