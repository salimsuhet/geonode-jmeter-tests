#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Uso: gen-report.sh <pasta-dos-jtls>"
  exit 1
fi

RUN_DIR="$1"
echo "Gerando relatórios para: ${RUN_DIR}"

for jtl in ${RUN_DIR}/*.jtl; do
  NAME=$(basename "${jtl}" .jtl)
  REPORT_OUT="${RUN_DIR}/${NAME}-report"

  echo "Criando relatório HTML para ${NAME}..."

  jmeter -g "${jtl}" -o "${REPORT_OUT}"
done

echo "=== Relatórios gerados com sucesso ==="
