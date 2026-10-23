# bugbounty-toolkit (HexRootADM)

> ⚠️ Leia o **[AVISO.md](AVISO.md)** antes de usar: material exclusivamente educacional, uso só autorizado.

> 🔎 **OSINT:** veja a lista de buscadores para recon em [comandos/osint-search-engines.md](comandos/osint-search-engines.md).
>
> 🤖 **AI Security:** trilha de estudo de segurança de LLMs em [comandos/trilha-ai-security.md](comandos/trilha-ai-security.md).
>
> ⛓️ **Blockchain com Python:** trilha didática em [comandos/blockchain-python.md](comandos/blockchain-python.md).

Container Docker com um pipeline de reconhecimento pronto para bug bounty **autorizado**: enumera subdomínios, verifica quais estão vivos, coleta URLs históricas e escaneia vulnerabilidades conhecidas com templates do Nuclei.

Inspirado na organização de dicas do [KingOfBugBountyTips](https://github.com/KingOfBugbounty/KingOfBugBountyTips) (metodologia e categorias) e em boas práticas de projetos como [Claude-BugHunter](https://github.com/elementalsouls/Claude-BugHunter) (gate de validação, escopo explícito do que a skill não cobre), reimplementado do zero como pipeline automatizado em container, sem copiar conteúdo de nenhum dos dois.

## ⚠️ Aviso legal

Use **somente** contra domínios para os quais você tem autorização explícita — um programa de bug bounty que inclui aquele escopo, um contrato de pentest, ou infraestrutura sua. Varredura sem autorização pode configurar crime (invasão de dispositivo, no Brasil: Lei 12.737/2012). O autor não se responsabiliza por uso indevido.

O container **exige** um arquivo `scope.txt` com os alvos autorizados antes de rodar (ou a variável `ALLOW_NO_SCOPE=1` para laboratório próprio). Isso é só uma trava de conveniência, não uma garantia técnica — a responsabilidade pelo uso é de quem roda o container.

## Ferramentas incluídas

| Ferramenta | Função |
|---|---|
| [subfinder](https://github.com/projectdiscovery/subfinder) | Enumeração passiva de subdomínios |
| [httpx](https://github.com/projectdiscovery/httpx) | Verifica quais hosts respondem HTTP(S) |
| [naabu](https://github.com/projectdiscovery/naabu) | Varredura de portas (opcional, `RUN_PORTSCAN=1`) |
| [gau](https://github.com/lc/gau) | Coleta URLs históricas (Wayback Machine, Common Crawl, OTX) |
| [nuclei](https://github.com/projectdiscovery/nuclei) | Escaneia vulnerabilidades conhecidas por templates |

## Uso

```bash
# 1. Build da imagem
docker build -t bugbounty-toolkit .

# 2. Defina seu escopo (SÓ domínios autorizados)
cp scope.txt.example scope.txt
nano scope.txt

# 3. Rode o pipeline completo
mkdir -p output
docker run --rm \
  -v "$(pwd)/scope.txt:/data/scope.txt:ro" \
  -v "$(pwd)/output:/data/output" \
  bugbounty-toolkit

# Variáveis opcionais:
#   RUN_PORTSCAN=1   ativa o naabu (varredura de portas)
#   RUN_NUCLEI=0     desativa o nuclei (pular o escaneamento de vulnerabilidades)
docker run --rm -e RUN_PORTSCAN=1 \
  -v "$(pwd)/scope.txt:/data/scope.txt:ro" \
  -v "$(pwd)/output:/data/output" \
  bugbounty-toolkit
```

Os resultados saem em `output/<timestamp>/`: `subdomains.txt`, `alive.txt`, `urls.txt`, `ports.txt` (se ativado) e `nuclei.txt`.

### Rodar um comando específico

A imagem também serve como "canivete": para rodar só uma ferramenta, sobrescreva o `CMD`:

```bash
docker run --rm -v "$(pwd)/scope.txt:/data/scope.txt:ro" bugbounty-toolkit \
  subfinder -dL /data/scope.txt -silent
```

## Comandos avulsos

Em [comandos/](comandos/) há cada comando do pipeline separado por etapa, para copiar e colar fora do `recon.sh`.

## Engenharia reversa mobile (para estudo)

Em [mobile-re/](mobile-re/) há um container separado, com JADX, Apktool e adb, para estudantes de pentest praticarem em APKs próprios ou de laboratório (crackmes). Documenta também o **REA (Reverse Engineer Anything)** — [morluto/rea](https://github.com/morluto/rea) —, projeto recente que conecta um agente de IA a ferramentas de engenharia reversa via MCP; não vem instalado na imagem, mas o README explica como adicionar.

## Skill para IA

Em `skills/bugbounty-recon/` há uma skill do Claude Code com a mesma metodologia, para quem usa IA no processo de recon. Copie a pasta para `~/.claude/skills/` (ou a pasta de skills do seu projeto) e invoque com `/bugbounty-recon`.

## Leitura recomendada

- [lostsec, "The Best Claude Code Setup for Bug Bounty Hunting"](https://infosecwriteups.com/the-best-claude-code-setup-for-bug-bounty-hunting-a16a0a50e811) (InfoSec Write-ups, ago/2026) — fluxo completo Claude Code + Burp MCP em fases, e atalhos sem MCP (requisição crua, JS, código-fonte); base das seções 10–12 da skill.
- [PortSwigger/mcp-server](https://github.com/PortSwigger/mcp-server) — extensão oficial do Burp Suite para MCP.
- [Claude-BugHunter](https://github.com/elementalsouls/Claude-BugHunter) — bundle de skills mais extenso, com gate de validação e matriz de ataque enterprise.
- [skills.sh](https://www.skills.sh), [Claude-Red (SnailSploit)](https://github.com/SnailSploit/Claude-Red), [Agentic-Bug-Hunter (Awarexone)](https://github.com/Awarexone/Agentic-Bug-Hunter) — outras coleções de skills da comunidade para inspiração.

## Licença

MIT — veja [LICENSE](LICENSE).
