# Hosts ativos

```bash
# Básico
httpx -l subdomains.txt -silent -o alive.txt

# Com título, código de status e tecnologia detectada
httpx -l subdomains.txt -silent -title -status-code -tech-detect -o alive_detalhado.txt

# Só os que respondem 200
httpx -l subdomains.txt -silent -mc 200 -o vivos_200.txt

# Capturar screenshot (requer chrome/chromium no container, não incluído por padrão)
# httpx -l subdomains.txt -silent -screenshot -o screenshots/
```
