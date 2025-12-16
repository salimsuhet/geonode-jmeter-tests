#!/bin/bash
set -e

AUTH_DIR="/nginx/auth"
HTPASSWD_FILE="${AUTH_DIR}/htpasswd"

AUTH_USER=${AUTH_USER:-admin}
AUTH_PASS=${AUTH_PASS:-admin123}

mkdir -p "${AUTH_DIR}"

if [ ! -f "${HTPASSWD_FILE}" ]; then
  echo "Criando htpasswd para o usuario ${AUTH_USER}"
  docker run --rm httpd:alpine \
    htpasswd -Bbn "${AUTH_USER}" "${AUTH_PASS}" > "${HTPASSWD_FILE}"
  echo "htpasswd criado com sucesso"
else
  echo "htpasswd já existe, pulando criação"
fi
