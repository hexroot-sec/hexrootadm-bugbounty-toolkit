#!/usr/bin/env python3
"""Blockchain didatica (so stdlib). Mostra encadeamento, proof-of-work e imutabilidade."""
import hashlib, time, json, sys

class Bloco:
    def __init__(self, indice, dados, hash_anterior):
        self.indice = indice
        self.timestamp = time.time()
        self.dados = dados
        self.hash_anterior = hash_anterior
        self.nonce = 0
        self.hash = self.calcular_hash()

    def calcular_hash(self):
        corpo = f"{self.indice}{self.timestamp}{self.dados}{self.hash_anterior}{self.nonce}"
        return hashlib.sha256(corpo.encode()).hexdigest()

    def minerar(self, dificuldade):
        alvo = "0" * dificuldade
        while not self.hash.startswith(alvo):
            self.nonce += 1
            self.hash = self.calcular_hash()

class Blockchain:
    def __init__(self, dificuldade=4):
        self.dificuldade = dificuldade
        self.cadeia = [self._genesis()]

    def _genesis(self):
        b = Bloco(0, "Bloco Genesis", "0")
        b.minerar(self.dificuldade)
        return b

    def adicionar(self, dados):
        anterior = self.cadeia[-1]
        novo = Bloco(len(self.cadeia), dados, anterior.hash)
        t0 = time.time()
        novo.minerar(self.dificuldade)
        self.cadeia.append(novo)
        print(f"  bloco #{novo.indice} minerado em {time.time()-t0:5.2f}s "
              f"(nonce={novo.nonce:>7}) hash={novo.hash[:16]}...")

    def valida(self):
        for i in range(1, len(self.cadeia)):
            at, ant = self.cadeia[i], self.cadeia[i-1]
            if at.hash != at.calcular_hash():         # conteudo mexido?
                return False, f"bloco #{i}: hash nao bate (foi alterado)"
            if at.hash_anterior != ant.hash:           # elo quebrado?
                return False, f"bloco #{i}: nao aponta para o anterior"
        return True, "cadeia integra"

# dificuldade pela linha de comando (padrao 4). Hardware fraco: 3-4. Bom processador: 5-6+.
DIF = int(sys.argv[1]) if len(sys.argv) > 1 else 4
print(f"=== Minerando (dificuldade = {DIF} zeros a esquerda) ===")
if DIF >= 6:
    print("  AVISO: dificuldade alta exige um bom processador; pode levar minutos.")
bc = Blockchain(dificuldade=DIF)
print(f"  bloco #0 (genesis) hash={bc.cadeia[0].hash[:16]}...")
bc.adicionar({"de": "Alice", "para": "Bob", "valor": 10})
bc.adicionar({"de": "Bob", "para": "Carol", "valor": 3})

ok, msg = bc.valida()
print(f"\n=== Validacao: {'OK' if ok else 'FALHOU'} -> {msg} ===")

print("\n=== Agora um atacante troca o valor do bloco #1 (10 -> 1000) ===")
bc.cadeia[1].dados = {"de": "Alice", "para": "Bob", "valor": 1000}
ok, msg = bc.valida()
print(f"Validacao: {'OK' if ok else 'FALHOU'} -> {msg}")
print("\n=> A troca quebrou o hash. E por isso que blockchain e 'imutavel':")
print("   mudar 1 byte invalida o bloco e todos os seguintes.")
