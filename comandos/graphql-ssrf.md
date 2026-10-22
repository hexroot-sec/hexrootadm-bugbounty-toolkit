# API, GraphQL e SSRF (comandos manuais)

Estes não têm ferramenta dedicada na imagem — usam `curl`, já presente no container.

```bash
# Testar introspecção do GraphQL (se habilitada em produção, já é achado a avaliar)
curl -s -X POST -H 'Content-Type: application/json' \
  -d '{"query":"{__schema{types{name}}}"}' https://alvo.com/graphql

# Procurar documentação de API exposta
for p in swagger.json openapi.json api-docs swagger-ui.html v1/swagger.json; do
  curl -s -o /dev/null -w "%{http_code} $p\n" "https://alvo.com/$p"
done

# Teste de SSRF em parâmetro que aceita URL (só se o programa permitir este tipo de teste)
curl -s "https://alvo.com/endpoint?url=http://169.254.169.254/latest/meta-data/"
```
