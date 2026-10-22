# Comandos prontos

Comandos avulsos de cada ferramenta do `bugbounty-toolkit`, para copiar e colar fora do pipeline automático (`recon.sh`). Pensados para rodar dentro do container:

```bash
docker run --rm -it -v "$(pwd)/scope.txt:/data/scope.txt:ro" -v "$(pwd)/output:/data/output" \
  --entrypoint bash bugbounty-toolkit
```

Depois, dentro do container, use os comandos dos arquivos abaixo.

Sempre use só contra alvos autorizados (ver aviso no README principal).

| Arquivo | Etapa |
|---|---|
| [subdominios.md](subdominios.md) | Enumeração de subdomínios |
| [hosts-ativos.md](hosts-ativos.md) | Verificação de hosts vivos e tecnologia |
| [urls-historicas.md](urls-historicas.md) | Coleta de URLs (Wayback/Common Crawl) |
| [portas.md](portas.md) | Varredura de portas |
| [vulnerabilidades.md](vulnerabilidades.md) | Templates do Nuclei |
| [graphql-ssrf.md](graphql-ssrf.md) | Descoberta de API/GraphQL, testes manuais de SSRF |
