# 🔎 Buscadores para OSINT & Recon

Lista de motores de busca úteis para reconhecimento em pentest e bug bounty — mapeamento
de superfície de ataque, DNS, certificados, vazamentos e inteligência de ameaças.

> ⚠️ **Uso autorizado e educacional.** Use apenas contra alvos que você possui ou tem
> autorização expressa para testar. Consulta a esses serviços é passiva, mas o uso do que
> for descoberto segue as regras do programa/contrato. Veja o [AVISO.md](../AVISO.md).

## 🌐 Superfície de ataque & dispositivos expostos

| Serviço | Link | Para quê |
|---|---|---|
| **Shodan** | https://shodan.io | Busca de dispositivos e IoT na internet |
| **Censys** | https://censys.io | Dados de varredura da internet (hosts, certs) |
| **Fofa** | https://fofa.info | Busca de "cyberspace" (ativos expostos) |
| **ZoomEye** | https://zoomeye.org | Mapeamento de cyberspace |
| **Hunter** | https://hunter.how | Descoberta de ativos |
| **Netlas** | https://netlas.io | Superfície de ataque |
| **Onyphe** | https://onyphe.io | Defesa cibernética / exposição |
| **FullHunt** | https://fullhunt.io | Superfície de ataque |
| **Quake** | https://quake.360.net | Busca de cyberspace (360) |

## 🧬 DNS, subdomínios & certificados

| Serviço | Link | Para quê |
|---|---|---|
| **DNSDumpster** | https://dnsdumpster.com | Recon de DNS e subdomínios |
| **crt.sh** | https://crt.sh | Busca em logs de Certificate Transparency |
| **SecurityTrails** | https://securitytrails.com | Histórico de DNS |
| **URLScan** | https://urlscan.io | Análise de URLs e páginas |

## 🚨 Vazamentos, ameaças & reputação

| Serviço | Link | Para quê |
|---|---|---|
| **Leakix** | https://leakix.net | Detecção de vazamentos |
| **GreyNoise** | https://greynoise.io | Identifica scanners/ruído da internet |
| **CriminalIP** | https://criminalip.io | Inteligência de ameaças |
| **Pulsedive** | https://pulsedive.com | Inteligência de ameaças |
| **VirusTotal** | https://virustotal.com | Análise de arquivos e URLs |

## 💻 Busca em código-fonte

| Serviço | Link | Para quê |
|---|---|---|
| **PublicWWW** | https://publicwww.com | Busca em código-fonte de páginas (HTML/JS) |
| **Grep.app** | https://grep.app | Busca de código no GitHub |

## 📧 E-mails, pessoas & credenciais vazadas

| Serviço | Link | Para quê |
|---|---|---|
| **Hunter.io** | https://hunter.io | Encontra e-mails corporativos por domínio |
| **Have I Been Pwned** | https://haveibeenpwned.com | Verifica se e-mail/senha apareceu em vazamentos |
| **Dehashed** | https://dehashed.com | Busca em bases de vazamentos (pago) |
| **Holehe** | https://github.com/megadose/holehe | Checa em quais sites um e-mail tem conta |
| **theHarvester** | https://github.com/laramies/theHarvester | Coleta e-mails/subdomínios de fontes públicas |
| **IntelligenceX** | https://intelx.io | Busca em pastes, leaks e dados históricos |

## 🔦 Google Dorks & busca avançada

| Recurso | Link | Para quê |
|---|---|---|
| **Google Hacking Database (GHDB)** | https://www.exploit-db.com/google-hacking-database | Catálogo de dorks prontos |
| **DuckDuckGo / Bing** | https://duckduckgo.com | Operadores próprios; úteis quando o Google limita |

Operadores mais usados (ajuste `alvo.com`):

```text
site:alvo.com                      # só páginas do domínio
site:alvo.com -www                 # tenta achar subdomínios
site:alvo.com filetype:pdf         # documentos expostos (pdf, xls, docx, env, sql...)
site:alvo.com inurl:admin          # painéis / rotas sensíveis
site:alvo.com intitle:"index of"   # listagem de diretórios
site:pastebin.com "alvo.com"       # vazamentos em pastes
site:github.com "alvo.com" password # segredos em código público
"alvo.com" ext:log | ext:env | ext:bak  # arquivos de config/backup
```

> Dork é consulta pública — não invade nada. O cuidado é no **uso** do que achar: só dentro do escopo autorizado.

## 🕰️ Wayback & arquivos históricos

| Serviço / Ferramenta | Link | Para quê |
|---|---|---|
| **Wayback Machine** | https://web.archive.org | Versões antigas de páginas e endpoints removidos |
| **archive.today** | https://archive.ph | Snapshots independentes do Wayback |
| **gau** | https://github.com/lc/gau | Puxa URLs históricas (Wayback, Common Crawl, OTX) |
| **waybackurls** | https://github.com/tomnomnom/waybackurls | URLs conhecidas de um domínio pelo Wayback |
| **Common Crawl** | https://commoncrawl.org | Índice gigante da web para mineração de URLs |

> Histórico é mina de ouro: endpoints de API antigos, parâmetros esquecidos e páginas que
> "sumiram" mas continuam no ar costumam aparecer aqui.
---

💡 **Dica de workflow:** comece por `crt.sh` + `SecurityTrails` (subdomínios e DNS histórico),
cruze com `Shodan`/`Censys` (o que está exposto), passe o JS/código por `Grep.app`/`PublicWWW`, resgate endpoints antigos com `gau`/Wayback
e valide hosts vivos com o pipeline do toolkit (`subfinder → httpx`). Vários desses exigem
cadastro gratuito; alguns têm limite de consultas sem conta paga.
