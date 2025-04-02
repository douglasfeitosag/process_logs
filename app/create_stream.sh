#!/bin/bash
set -e

echo "Creating stream..."

RESPONSE=$(curl -i -u $RABBITMQ_USER:$RABBITMQ_PASS -X POST \
  "http://$RABBITMQ_HOST:$RABBITMQ_PORT/api/streams/$RABBITMQ_STREAM")

echo "Response from RabbitMQ: $RESPONSE"

echo "Finishning create stream..."