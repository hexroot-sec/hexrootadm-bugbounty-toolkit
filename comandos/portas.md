# Varredura de portas

Mais intrusivo: confira a política do programa de bug bounty antes de usar.

```bash
# Portas mais comuns
naabu -l alive.txt -silent -o ports.txt

# Top 1000 portas
naabu -l alive.txt -top-ports 1000 -silent -o ports_top1000.txt

# Taxa de pacotes reduzida (mais discreto)
naabu -l alive.txt -rate 100 -silent -o ports.txt
```
