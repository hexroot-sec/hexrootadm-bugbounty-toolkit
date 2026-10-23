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

---

💡 **Dica de workflow:** comece por `crt.sh` + `SecurityTrails` (subdomínios e DNS histórico),
cruze com `Shodan`/`Censys` (o que está exposto), passe o JS/código por `Grep.app`/`PublicWWW`
e valide hosts vivos com o pipeline do toolkit (`subfinder → httpx`). Vários desses exigem
cadastro gratuito; alguns têm limite de consultas sem conta paga.
