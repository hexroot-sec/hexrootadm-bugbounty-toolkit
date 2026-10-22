#!/usr/bin/env bash
# Pipeline de reconhecimento: subfinder -> httpx -> (naabu) -> gau -> nuclei
# Lê /data/scope.txt (um domínio por linha) e escreve em /data/output/<timestamp>/
set -euo pipefail

SCOPE_FILE="/data/scope.txt"
OUT_DIR="/data/output/$(date -u +%Y-%m-%dT%H%M%SZ)"
mkdir -p "$OUT_DIR"

echo "[*] Escopo: $SCOPE_FILE"
echo "[*] Saída:  $OUT_DIR"

echo "[1/5] subfinder: enumerando subdomínios..."
subfinder -dL "$SCOPE_FILE" -silent -o "$OUT_DIR/subdomains.txt"

echo "[2/5] httpx: verificando hosts ativos..."
httpx -l "$OUT_DIR/subdomains.txt" -silent -o "$OUT_DIR/alive.txt"

if [ "${RUN_PORTSCAN:-0}" = "1" ]; then
    echo "[3/5] naabu: varredura de portas (RUN_PORTSCAN=1)..."
    naabu -l "$OUT_DIR/alive.txt" -silent -o "$OUT_DIR/ports.txt"
else
    echo "[3/5] naabu: pulado (defina RUN_PORTSCAN=1 para ativar)"
fi

echo "[4/5] gau: coletando URLs históricas (Wayback/Common Crawl/OTX)..."
: > "$OUT_DIR/urls.txt"
while read -r host; do
    gau --subs "$host" >> "$OUT_DIR/urls.txt" 2>/dev/null || true
done < "$SCOPE_FILE"
sort -u -o "$OUT_DIR/urls.txt" "$OUT_DIR/urls.txt"

if [ "${RUN_NUCLEI:-1}" = "1" ]; then
    echo "[5/5] nuclei: escaneando vulnerabilidades conhecidas..."
    nuclei -update-templates -silent || true
    nuclei -l "$OUT_DIR/alive.txt" -silent -o "$OUT_DIR/nuclei.txt"
else
    echo "[5/5] nuclei: pulado (RUN_NUCLEI=0)"
fi

echo "[*] Concluído. Resultados em $OUT_DIR"
