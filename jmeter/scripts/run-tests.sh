#!/bin/bash
set -e

echo "=== GeoNode Load Testing – Running Test Plans ==="

# Diretórios dentro do container
TEST_PLANS_DIR="/tests-plans"
REPORTS_DIR="/reports"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RUN_DIR="${REPORTS_DIR}/run_${TIMESTAMP}"

mkdir -p "${RUN_DIR}"

echo "Gerando diretório de execução: ${RUN_DIR}"

# Carregando variáveis do ambiente
echo "Usando parametros:"
echo "BASE_URL=${GEONODE_BASE_URL}"
echo "THREADS=${THREADS}"
echo "RAMPUP=${RAMPUP}"
echo "DURATION=${DURATION}"
echo "UPLOAD_FILE=${UPLOAD_FILE}"

# Verifica se arquivo de upload existe
if [ ! -f "${UPLOAD_FILE}" ]; then
  echo "ERRO: Arquivo para upload não encontrado: ${UPLOAD_FILE}"
  exit 1
fi

# Loop pelos planos JMX
for plan in ${TEST_PLANS_DIR}/*.jmx; do
  NAME=$(basename "${plan}" .jmx)
  RESULT_FILE="${RUN_DIR}/${NAME}.jtl"

  echo "----------------------------------------------------"
  echo "Executando teste: ${NAME}"
  echo "Plano: ${plan}"
  echo "Saída: ${RESULT_FILE}"
  echo "----------------------------------------------------"

  jmeter -n -t "${plan}" -l "${RESULT_FILE}"

done

echo "=== Todos os testes executados! ==="
echo "Executando relatório automático..."

# Chama script de relatório
/scripts/gen-report.sh "${RUN_DIR}"

echo "Relatórios prontos em: ${RUN_DIR}"
