# URLs históricas

```bash
# Um domínio
gau alvo.com | sort -u > urls.txt

# Incluindo subdomínios
gau --subs alvo.com | sort -u > urls.txt

# Filtrar por extensões sensíveis
grep -E '\.(env|sql|bak|log|zip|config)$' urls.txt

# Filtrar URLs com parâmetros (candidatas a IDOR/SSRF/injeção)
grep '?' urls.txt | sort -u > urls_com_parametros.txt
```
