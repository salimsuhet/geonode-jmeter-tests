#!/bin/bash
set -e

# Carrega variáveis do .env de forma segura
if [ -f ".env" ]; then
  set -a
  source .env
  set +a
fi

DOMAIN="${CERTBOT_DOMAIN}"
EMAIL="${CERTBOT_EMAIL}"

if [ -z "${DOMAIN}" ] || [ -z "${EMAIL}" ]; then
  echo "ERROR: CERTBOT_DOMAIN e CERTBOT_EMAIL devem estar definidos no .env"
  exit 1
fi

CERT_PATH="/etc/letsencrypt/live/${DOMAIN}"

if [ -d "${CERT_PATH}" ]; then
  echo "Certificado já existe para ${DOMAIN}"
  exit 0
fi

echo "Gerando certificado para ${DOMAIN}"

docker compose run --rm certbot certonly \
  --webroot \
  --webroot-path=/var/www/certbot \
  --email "${EMAIL}" \
  --agree-tos \
  --no-eff-email \
  -d "${DOMAIN}"

echo "Certificado criado com sucesso"
