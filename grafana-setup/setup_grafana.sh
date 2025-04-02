#!/bin/bash

TOKEN_FILE="/var/lib/grafana/auth_token.txt"

# Verifica se o arquivo existe e não está vazio
if [[ -f "$TOKEN_FILE" && -s "$TOKEN_FILE" ]]; then
  AUTH_TOKEN=$(cat "$TOKEN_FILE")
  echo "Grafana API Token already exists: $AUTH_TOKEN"
  exit 0
fi

echo "Grafana API Token not found. Creating a new one..."

echo "Creating Service Account in Grafana..."

# Criando um Service Account
SA_RESPONSE=$(curl -s -X POST "http://$GF_SECURITY_ADMIN_USER:$GF_SECURITY_ADMIN_PASSWORD@grafana:3000/api/serviceaccounts" \
    -H "Content-Type: application/json" \
    --data '{"name": "elixir_app_service_account", "role": "Admin"}')

# Extrai o ID do Service Account
SA_ID=$(echo "$SA_RESPONSE" | jq -r '.id' 2>/dev/null || echo "")

# Se o Service Account já existir, busca o ID
if [[ -z "$SA_ID" || "$SA_ID" == "null" ]]; then
  echo "Service Account already exists. Retrieving existing ID..."
  SA_ID=$(curl -s -X GET "http://$GF_SECURITY_ADMIN_USER:$GF_SECURITY_ADMIN_PASSWORD@grafana:3000/api/serviceaccounts" \
    | jq -r '.[] | select(.name=="elixir_app_service_account") | .id' 2>/dev/null || echo "")

  if [[ -z "$SA_ID" ]]; then
    echo "Error retrieving existing Service Account ID."
    exit 1
  fi
fi

echo "Service Account ID: $SA_ID"

echo "Generating API Token for the Service Account..."

# Criando um token para o Service Account
TOKEN_RESPONSE=$(curl -s -X POST "http://$GF_SECURITY_ADMIN_USER:$GF_SECURITY_ADMIN_PASSWORD@grafana:3000/api/serviceaccounts/$SA_ID/tokens" \
    -H "Content-Type: application/json" \
    --data '{"name": "elixir_app_token"}')

# Extraindo o token
AUTH_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.key' 2>/dev/null || echo "")

if [[ -z "$AUTH_TOKEN" || "$AUTH_TOKEN" == "null" ]]; then
  echo "Error generating Grafana API Token."
  echo "Full response: $TOKEN_RESPONSE"
  exit 1
fi

echo "Token successfully generated!"
echo "$AUTH_TOKEN" > "$TOKEN_FILE"
echo "Grafana API Token saved in $TOKEN_FILE: $AUTH_TOKEN"
