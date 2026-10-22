# Vulnerabilidades conhecidas (Nuclei)

```bash
# Atualizar templates antes de rodar
nuclei -update-templates

# Varredura completa
nuclei -l alive.txt -silent -o nuclei.txt

# Só severidade alta/crítica
nuclei -l alive.txt -severity high,critical -silent -o nuclei_criticos.txt

# Só uma categoria de templates (ex.: exposições de configuração)
nuclei -l alive.txt -t exposures/ -silent -o nuclei_exposures.txt

# Um único alvo, com saída detalhada
nuclei -u https://alvo.com -silent
```

Trate todo achado do Nuclei como pista a confirmar manualmente — falso positivo é comum.
