# 🤖 Trilha de AI Security (segurança de LLMs)

Roteiro de estudo para **segurança ofensiva de aplicações com IA/LLM**. Serve de preparação
para vagas de AI Security / Red Team de IA e como material para estudantes.

> ⚠️ **Uso autorizado e educacional.** Teste prompt injection/jailbreak apenas em sistemas
> próprios, em labs ou em programas que autorizam. Veja o [AVISO.md](../AVISO.md).

## 🧭 Base — OWASP Top 10 para LLM
Comece por aqui. É o "mapa" da área.
- **LLM01 – Prompt Injection** (direta e indireta)
- **LLM02 – Insecure Output Handling** (saída do modelo usada sem sanitizar → XSS/SSRF/RCE)
- **LLM03 – Training Data Poisoning**
- **LLM04 – Model Denial of Service**
- **LLM05 – Supply Chain** (modelos/plugins/datasets de terceiros)
- **LLM06 – Sensitive Information Disclosure** (vazamento de dado/segredo pelo modelo)
- **LLM07 – Insecure Plugin/Tool Design**
- **LLM08 – Excessive Agency** (agente com poder/permissão demais)
- **LLM09 – Overreliance**
- **LLM10 – Model Theft**

Referência: https://genai.owasp.org  (OWASP Top 10 for LLM Applications)

## 🎯 Os 2 ataques que mais caem
1. **Prompt Injection direta** — o usuário manda instruções que sobrescrevem o "system prompt".
   Ex.: *"ignore as instruções anteriores e..."*.
2. **Prompt Injection indireta** — a instrução maliciosa vem de um dado que o modelo lê
   (uma página, um e-mail, um PDF). É a mais perigosa em agentes que navegam/leem arquivos.

Encadeamento clássico: injection → **exfiltração de dados** (fazer o modelo mandar segredo pra
uma URL do atacante) ou → **abuso de ferramenta** (fazer o agente executar uma ação indevida).

## 🧪 Labs para praticar (grátis / legais)
- **Gandalf** (Lakera) — https://gandalf.lakera.ai — jogo de prompt injection por níveis
- **PortSwigger Web Security Academy — Web LLM attacks** — https://portswigger.net/web-security/llm-attacks
- **HackTheBox / TryHackMe** — trilhas de AI/LLM
- **Prompt Airlines, DoubleSpeak, MyLLMBank** — CTFs de prompt
- Monte seu próprio lab: um app pequeno em Python chamando uma API de LLM e tente quebrar o seu.

## 🛡️ Defesa (o outro lado — cai em entrevista)
- Separar instrução de dado; tratar TODA entrada externa como não confiável.
- Validar/sanitizar a **saída** antes de usar (nunca renderizar HTML cru, nunca `eval`).
- Princípio do menor privilégio em ferramentas/plugins do agente (Excessive Agency).
- Allowlist de domínios para ações de rede; humano no loop para ações sensíveis.

## 🐍 Base técnica que sustenta tudo
- **Python 3** — automatizar testes e montar PoCs (requests, scripts de fuzzing de prompt).
- Entender **APIs de LLM** (mensagens, system/user/tool, tokens).
- Ler **inglês técnico** (quase todo material bom é em inglês — vale evoluir junto).

## 🗺️ Ordem sugerida
1. Ler o OWASP LLM Top 10 (1 semana, sem pressa).
2. Zerar o **Gandalf** (sente na pele a injection).
3. Fazer o módulo **Web LLM attacks** do PortSwigger.
4. Montar um lab próprio em Python e reproduzir LLM01, LLM02 e LLM06.
5. Escrever um write-up (ótimo conteúdo pro canal e pro portfólio).
