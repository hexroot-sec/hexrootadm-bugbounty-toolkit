#!/usr/bin/env bash
set -euo pipefail

cat <<'EOF'
==============================================================================
 bugbounty-toolkit — AVISO LEGAL

 Use esta imagem SOMENTE contra alvos para os quais você tem autorização
 explícita (programa de bug bounty em escopo, contrato de pentest, ou
 infraestrutura própria). Varredura sem autorização pode ser crime.

 O autor não se responsabiliza pelo uso indevido desta ferramenta.
==============================================================================
EOF

SCOPE_FILE="/data/scope.txt"

if [ "${ALLOW_NO_SCOPE:-0}" != "1" ] && [ ! -s "$SCOPE_FILE" ]; then
    echo "ERRO: nenhum arquivo de escopo encontrado em $SCOPE_FILE" >&2
    echo "Monte um scope.txt com os domínios/hosts autorizados, um por linha:" >&2
    echo "  docker run -v \$(pwd)/scope.txt:/data/scope.txt ... " >&2
    echo "Ou, só para laboratório próprio, defina ALLOW_NO_SCOPE=1." >&2
    exit 1
fi

exec "$@"
