# Kage Bunshin System

Sistema de criação, movimentação, combate e gerenciamento de clones das sombras, desenvolvido em BYOND Dream Maker (DM).

## Funcionalidades

- Criação de até 3 clones das sombras.
- Consumo de chakra para invocar clones.
- Integração com o sistema de selos de mãos (Handseals).
- Tempo de recarga da habilidade.
- Atributos individuais de ataque e defesa dos clones.
- Detecção automática de inimigos próximos.
- Combate autônomo contra adversários.
- Movimentação controlada pelo jogador através de cliques no mapa.
- Reconhecimento de clones aliados para evitar ataques entre clones do mesmo proprietário.
- Gerenciamento individual de vida dos clones.
- Desaparecimento automático após 30 segundos.
- Destruição do clone ao atingir zero de vida.
- Desfazimento manual de todos os clones pertencentes ao jogador.
- Efeitos visuais de fumaça durante a criação e o desaparecimento.

## Funcionamento

O jogador utiliza o Kage Bunshin no Jutsu após cumprir os requisitos de chakra e executar os selos de mãos com sucesso.

Cada clone é criado com atributos individuais calculados a partir das características do seu criador.

Os clones conseguem detectar e atacar adversários próximos automaticamente. O jogador também pode direcionar seus clones clicando em um destino no mapa.

Cada clone possui seus próprios valores de vida e ataque. Quando derrotado ou ao atingir seu tempo máximo de existência, desaparece.

## Sistema de Combate

O ataque individual dos clones é calculado com base no atributo de ataque do criador:

`Ataque = 5 + round(Ataque do Criador * 0.3)`

O ataque mínimo de cada clone é 10.

A defesa é calculada utilizando:

`Defesa = round(Defesa do Criador * 0.1)`

## Tecnologias

- BYOND
- Dream Maker (DM)

## Dependências

- Handseals System
- Atributos de personagem compatíveis.
- Procedimentos de combate compatíveis.

## Autor

Wander3r
