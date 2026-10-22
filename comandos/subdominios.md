# Subdomínios

```bash
# Básico, um domínio
subfinder -d alvo.com -silent -o subdomains.txt

# Vários domínios de uma vez (arquivo com 1 por linha)
subfinder -dL scope.txt -silent -o subdomains.txt

# Com todas as fontes (mais lento, mais cobertura)
subfinder -d alvo.com -all -silent -o subdomains.txt

# Saída em JSON, com a fonte de cada achado
subfinder -d alvo.com -silent -oJ -o subdomains.json
```
