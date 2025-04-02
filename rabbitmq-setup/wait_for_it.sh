#!/bin/bash
set -e

host="$1"
port="$2"
shift 2
cmd="$@"

echo "Waiting for RabbitMQ to be available on $host:$port..."

while ! nc -z "$host" "$port"; do
  echo "Still waiting for RabbitMQ..."
  sleep 3
done

echo "RabbitMQ is up! Running command: $cmd"
exec $cmd
