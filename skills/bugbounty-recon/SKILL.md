---
name: bugbounty-recon
description: Use ao fazer reconhecimento de bug bounty ou pentest AUTORIZADO — enumeração de subdomínios, verificação de hosts vivos, descoberta de APIs/Swagger/GraphQL, coleta de URLs históricas e varredura de vulnerabilidades conhecidas. Exige confirmar que o alvo está em escopo autorizado antes de sugerir qualquer comando contra ele.
---

# Reconhecimento de Bug Bounty — HexRootADM

Metodologia de recon organizada por etapa, pensada para ser usada com o container `bugbounty-toolkit` (subfinder, httpx, naabu, gau, nuclei) ou com as ferramentas instaladas localmente.

## 0. Antes de qualquer comando: confirmar escopo

Nunca sugira ou rode um comando de rede contra um alvo sem o usuário confirmar que:
- O domínio está dentro do escopo de um programa de bug bounty ativo, OU
- É infraestrutura do próprio usuário, OU
- Há contrato de pentest cobrindo aquele alvo.

Se não houver essa confirmação, peça-a antes de prosseguir. Nunca rode contra domínios de terceiros sem programa de bug bounty público que os cubra.

## 1. Enumeração de subdomínios

Objetivo: mapear a superfície (subdomínios esquecidos costumam ter proteção mais fraca).

```bash
subfinder -dL scope.txt -silent -o subdomains.txt
```

Fontes complementares a sugerir ao usuário: certificados (crt.sh), DNS reverso, registros de transparência de certificados, buscas em motores (`site:`), repositórios de código (GitHub dorks) por subdomínios vazados em configs.

## 2. Hosts vivos

```bash
httpx -l subdomains.txt -silent -o alive.txt -title -status-code -tech-detect
```

`-tech-detect` ajuda a priorizar: tecnologias antigas/conhecidas por CVEs valem investigação manual primeiro.

## 3. Descoberta de APIs e schemas

- **Swagger/OpenAPI:** tentar caminhos comuns (`/swagger.json`, `/openapi.json`, `/api-docs`) nos hosts vivos.
- **GraphQL:** testar introspecção em `/graphql`:
  ```bash
  curl -s -X POST -H 'Content-Type: application/json' \
    -d '{"query":"{__schema{types{name}}}"}' https://alvo/graphql
  ```
  Se a introspecção estiver habilitada em produção, já é um achado a reportar (dependendo da política do programa).
- Procurar coleções do Postman ou specs expostas acidentalmente (buscas em motores, `.git/` exposto).

## 4. Coleta de URLs históricas

```bash
gau --subs alvo.com | sort -u > urls.txt
```

Filtrar por padrões interessantes: parâmetros de URL (possível IDOR/SSRF), extensões sensíveis (`.env`, `.sql`, `.bak`, `.log`), endpoints de admin/debug.

## 5. Varredura de portas (opcional, mais intrusivo)

```bash
naabu -l alive.txt -silent -o ports.txt
```

Avise o usuário: varredura de portas é mais barulhenta e alguns programas pedem para evitá-la ou limitar a taxa.

## 6. Vulnerabilidades conhecidas

```bash
nuclei -l alive.txt -silent -o nuclei.txt
```

Trate resultados do Nuclei como pistas a confirmar manualmente, não como relatório pronto — falso positivo é comum.

## 7. Indicadores a revisar manualmente

- **SSRF:** parâmetros que aceitam URL (`url=`, `callback=`, `webhook=`, `redirect=`) — testar apontando para `http://169.254.169.254` (metadado de nuvem) só se o programa permitir esse tipo de teste.
- **Vazamento de tokens/segredos:** buscar em `urls.txt` e em JS coletado por padrões como `api_key`, `Bearer `, `AKIA` (AWS), `-----BEGIN`.
- **IDOR:** endpoints com IDs sequenciais ou previsíveis nos parâmetros coletados.

## 8. Gate de validação antes de reportar

Antes de escrever qualquer relatório, confirme cada item:
1. O alvo está no `scope.txt` / escopo do programa, sem exclusão específica para essa classe de bug?
2. O impacto está na lista de severidades aceitas pelo programa (muitos excluem self-XSS, logout CSRF, falta de rate-limit sozinha, etc.)?
3. Você reproduziu o bug do zero, com passos limpos, mais de uma vez?
4. Não é duplicata óbvia de algo já bem documentado publicamente sobre aquele alvo?
5. A evidência prova o impacto sem extrair mais dados reais do que o necessário?

Se qualquer resposta for "não" ou "não sei", pare e resolva antes de reportar.

## 9. Reportar

Sempre seguir a política de divulgação do programa (escopo, formato de relatório, proibição de automação agressiva). Nunca extrair ou exfiltrar dados reais além do mínimo necessário para provar o impacto.

## 10. Integração opcional: Burp Suite via MCP

Baseado em [lostsec, "The Best Claude Code Setup for Bug Bounty Hunting"](https://infosecwriteups.com/the-best-claude-code-setup-for-bug-bounty-hunting-a16a0a50e811) (InfoSec Write-ups, ago/2026).

1. No Burp Suite, instale a extensão oficial [PortSwigger/mcp-server](https://github.com/PortSwigger/mcp-server) pelo BApp Store.
2. Na aba da extensão, em **Auto-Approved HTTP Targets**, adicione o domínio/subdomínio do alvo (ou um wildcard `*.alvo.com`) — sem isso, Claude pede confirmação a cada requisição.
3. Carregue o JAR gerado pela extensão em **Extensions** no Burp e confira a porta local que ela abre.
4. No terminal: `claude mcp add burp --transport sse http://127.0.0.1:9876` (a porta pode variar — confira a tela da extensão).
5. Em **Target** no Burp, coloque o alvo em escopo e filtre o histórico por "Show only in-scope items".
6. Navegue manualmente pelo app (login, busca, carrinho, APIs) para gerar histórico rico, e opcionalmente use **Engagement Tools → Discover Content** para achar caminhos escondidos.

Com isso, o agente lê o histórico do proxy e pode repetir requisições. É poder real sobre uma sessão ativa: use só em alvos já confirmados em escopo (passo 0), e revise toda requisição antes de enviar.

### Fluxo em fases (com Burp MCP)

Depois de coletar histórico suficiente, peça em etapas (ou combine num prompt único "ROLE/SCOPE/FASES" para rodar sozinho):
1. **Organizar:** listar e resumir as requisições do histórico, isolar as do alvo, montar tabela de endpoints de API, varrer por dados sensíveis (senhas, tokens, chaves).
2. **Mapear superfície:** separar por classe de bug — parâmetros de busca (injeção), IDs numéricos (IDOR), endpoints admin/upload/API, JS com segredos embutidos. Sair com uma lista priorizada por classe.
3. **Testar (nesta ordem costuma render mais em e-commerce/SaaS):** lógica de negócio (cupom, preço, checkout) → IDOR/controle de objeto → autenticação/sessão (credenciais fracas, enumeração de usuário, rate limit) → controle de acesso → injeção (SQLi, XSS, SSTI) → fora de banda (SSRF/XXE via Collaborator) → upload. Depois de cada primitiva confirmada, pergunte o que ela destrava encadeada com outra (um IDOR pode virar takeover; uma chave vazada no JS pode virar acesso de admin).
4. **Gate de validação** (seção 8) antes de reportar — reproduza cada achado do zero, mais de uma vez.
5. **Relatório final:** título, severidade, endpoint, passos, evidência (requisição+resposta), impacto de negócio, correção — nunca inflar severidade, e dizer claramente quando nada foi confirmado.

## 11. Sem Burp MCP: analisar artefatos isolados

Quando não vale a pena montar o MCP (um alvo pequeno, ou só uma dúvida pontual), dê ao Claude só o artefato relevante e peça observações separadas de hipóteses — nunca afirmar vulnerabilidade sem evidência:

- **Uma requisição crua salva em `.txt`:** peça para listar parâmetros controláveis pelo usuário, mecanismo de autenticação, candidatos a IDOR/BOLA, pontos de injeção e cabeçalhos relevantes.
- **Um arquivo JavaScript** (local ou por URL): peça para extrair endpoints, métodos, parâmetros, segredos embutidos, rotas administrativas/debug e sinks DOM interessantes.
- **Vários arquivos JS numa pasta:** peça um mapa consolidado da superfície de ataque, deduplicado, com os 10 achados mais relevantes para testar manualmente.
- **Código-fonte, quando disponível:** peça revisão de autenticação, controle de acesso, validação de entrada, injeção, exposição de dados sensíveis e lógica de negócio — sempre apontando a linha e separando "confirmado" de "hipótese".
- **Projeto completo** (pastas `recon/`, `requests/`, `javascript/`, `source/` juntas): peça para correlacionar tudo num só mapa de superfície, inventário de API e plano de teste priorizado.

Em todos os casos, feche com um relatório no mesmo formato da seção 9, separando achados confirmados de observações e hipóteses.

## 12. Criar novas skills a partir da sua própria metodologia

Se você (o usuário) já tem uma metodologia própria para uma classe de bug (ex.: suas anotações sobre open redirect ou XSS), peça ao Claude para convertê-la numa skill nova: nome, descrição, metodologia de detecção, fluxo de teste, payloads, ferramentas, critérios de validação e formato de relatório — fiel ao que você já pratica, sem inventar técnica que não esteja na sua fonte. Referências de skills da comunidade para se inspirar (não instaladas por padrão aqui): [skills.sh](https://www.skills.sh), [Claude-BugHunter](https://github.com/elementalsouls/Claude-BugHunter), [Claude-Red (SnailSploit)](https://github.com/SnailSploit/Claude-Red), [Agentic-Bug-Hunter (Awarexone)](https://github.com/Awarexone/Agentic-Bug-Hunter).

## 13. Fora de escopo desta skill

Esta skill não cobre, e não deve ser usada para:
- Explorar vulnerabilidade 0-day contra alvo sem autorização.
- Ferramentas de pós-exploração, persistência ou C2.
- Evasão de antivírus/EDR.
- Ataques internos de Active Directory ou movimentação lateral.
- Qualquer automação de varredura em massa, sem alvo específico autorizado.
