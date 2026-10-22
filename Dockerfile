# bugbounty-toolkit — imagem de reconhecimento para bug bounty autorizado
#
# Ferramentas: subfinder, httpx, naabu, nuclei (ProjectDiscovery) + gau (lc/gau).
# Build em duas etapas: compila em Go, copia só os binários para a imagem final.

FROM golang:1.22-bookworm AS builder

# naabu precisa de libpcap para compilar (CGO)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpcap-dev \
    && rm -rf /var/lib/apt/lists/*

ENV CGO_ENABLED=1
RUN go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest \
    && go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest \
    && go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest \
    && go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest \
    && go install -v github.com/lc/gau/v2/cmd/gau@latest

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates libpcap0.8 bash coreutils \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/subfinder /usr/local/bin/subfinder
COPY --from=builder /go/bin/httpx /usr/local/bin/httpx
COPY --from=builder /go/bin/naabu /usr/local/bin/naabu
COPY --from=builder /go/bin/nuclei /usr/local/bin/nuclei
COPY --from=builder /go/bin/gau /usr/local/bin/gau

COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY scripts/recon.sh /usr/local/bin/recon.sh
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/recon.sh

# Usuário sem privilégio (nunca rode ferramentas de rede como root sem necessidade)
RUN useradd -m -u 1000 hunter
USER hunter
WORKDIR /data

VOLUME ["/data"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/local/bin/recon.sh"]
