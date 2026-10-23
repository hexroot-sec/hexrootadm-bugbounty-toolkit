# ⛓️ Blockchain com Python — trilha didática

Como uma blockchain (e um bitcoin) funciona por dentro, em Python. Para estudantes e para
entender o conceito antes de mexer em moeda de verdade.

> 📝 **É material didático.** Os exemplos simples ensinam o encadeamento e o proof-of-work,
> mas **não são uma moeda**: não têm transações assinadas, carteira nem rede P2P.

## 🧪 Exemplo rodável (só biblioteca padrão)

Neste repo: [`exemplo_blockchain.py`](exemplo_blockchain.py). Roda assim:

```bash
nice -n 10 python3 -I comandos/exemplo_blockchain.py
```

Ele minera 3 blocos (dificuldade = 4 zeros), valida a cadeia e depois **altera um bloco**
pra mostrar que a validação acusa a fraude. Saída típica: cada bloco leva ~1 s num notebook fraco.

**O que observar:**
- O `nonce` sobe por força bruta até o hash começar com `0000` → isso é "minerar".
- Cada bloco guarda o `hash_anterior` → é o elo da corrente.
- Mudar 1 byte de um bloco quebra o hash dele e invalida os seguintes → imutabilidade.

## 📚 Para aprofundar

| Nível | Recurso | Link |
|---|---|---|
| Iniciante 🇧🇷 | felipemfp — "Entendendo como funciona uma blockchain com Python" | https://medium.com/@felipemfp/entendendo-como-funciona-uma-blockchain-com-python-4e5a66f09e16 |
| Iniciante | ecomunsing — "Build Your Own Blockchain" | http://ecomunsing.com/build-your-own-blockchain |
| Intermediário | Analytics Vidhya — PoW com nonce e dificuldade | https://www.analyticsvidhya.com/blog/2022/06/building-a-blockchain-in-python/ |
| Avançado ⭐ | Karpathy — "A from-scratch tour of Bitcoin in Python" (chaves secp256k1, transações assinadas) | http://karpathy.github.io/2021/06/21/blockchain/ |

## 🗺️ Ordem sugerida
1. Rodar o `exemplo_blockchain.py` aqui e ler o código.
2. Ler o artigo do felipemfp (mesmo conceito, em PT).
3. Subir para o Karpathy, que constrói um Bitcoin real (chaves, assinaturas) — aí você vê a
   diferença entre "corrente de hashes" e "moeda".
