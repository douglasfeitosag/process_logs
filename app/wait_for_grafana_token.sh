#!/bin/sh

TOKEN_FILE="/var/lib/grafana/auth_token.txt"
echo "Waiting for the Grafana token to be available..."

while [ ! -f "$TOKEN_FILE" ]; do
  echo "Token not available yet. Waiting..."
  sleep 1
done

echo "Token found! Elixir can start."
