# mobile-re — laboratório de engenharia reversa mobile (para estudo)

Container separado do `bugbounty-toolkit` principal: aqui o foco é **engenharia reversa de apps Android** (APK), para estudantes de pentest praticarem em apps próprios ou de CTF/laboratório (ex.: [OWASP MASTG Crackmes](https://github.com/OWASP/owasp-mastg), [DVHMA](https://github.com/proneetkarmakar/DVHMA)), nunca em apps de terceiros sem autorização.

## O que tem no container

| Ferramenta | Função |
|---|---|
| [JADX](https://github.com/skylot/jadx) | Decompila APK/DEX para Java legível |
| [Apktool](https://github.com/iBotPeaches/Apktool) | Desmonta/remonta recursos e smali do APK |
| Android Platform Tools (`adb`) | Comunicação com dispositivo/emulador |
| Node.js 22+ | Necessário para o REA (abaixo) |

**Não incluído de propósito:** Ghidra, IDA e Hopper (engines de binário nativo que o REA também usa) — são pesados, alguns pagos, e cada estudante deve instalar e licenciar por conta própria. Frida/Objection também ficaram de fora porque exigem instrumentar um app em execução (dispositivo real/emulador), fora do escopo de um container estático.

## REA (Reverse Engineer Anything)

Projeto novo, não incluído na imagem — instale e decida usar por sua conta:

- Repositório: https://github.com/morluto/rea (confirme sempre esse link; o README dele avisa que nomes parecidos não são oficiais)
- Site: https://rea.tools — pacote npm: `rea-agents`
- Conecta um agente de IA (Claude Code, Cursor, Codex etc.) via MCP a ferramentas de engenharia reversa: analisa APKs (manifesto, classes, métodos decompilados via JADX), apps Flutter, binários nativos (com Ghidra/IDA/Hopper), .NET, JS/Electron. **iOS não está listado como alvo suportado.**
- Requisitos: Node.js 22.x+ e npm; para Android, JADX + um JDK completo e `adb` (já inclusos neste container).
- Uso declarado pelo próprio projeto: pesquisa lícita, educação, interoperabilidade, preservação de software e análise de software próprio ou autorizado — nada além disso.

Para instalar dentro deste container (depois de buildar e entrar nele):

```bash
npx rea-agents setup
```

## Build e uso

```bash
docker build -t mobile-re .

# Decompilar um APK (monte a pasta com o apk)
docker run --rm -v "$(pwd)/apks:/data" mobile-re \
  jadx -d /data/saida /data/alvo.apk

# Abrir um shell interativo (para usar adb, apktool, rea, etc.)
docker run --rm -it -v "$(pwd)/apks:/data" --network host mobile-re bash
```

`--network host` só é necessário se for conectar num dispositivo/emulador via `adb` do host.

## Aviso legal

Use somente em APKs seus, de laboratório (crackmes, apps de CTF) ou com autorização explícita do dono do app. Engenharia reversa de apps de terceiros sem autorização pode violar termos de uso e, dependendo da jurisdição, a lei. O autor não se responsabiliza pelo uso indevido.
