# Decisões

Uma decisão por arquivo, separadas em pastas por assunto. Estas decisões são a fonte de verdade das regras do projeto: valem junto com a visão, as jornadas e o corte do MVP da esteira.

## Pastas

As pastas nascem junto com a primeira decisão do assunto. Sugestões de assunto: `arquitetura`, `business-rules`, `interface`, `dados`, `seguranca`, `work-process`.

## Formato de cada arquivo

Nome: `NNNN-titulo-curto.md`. O número tem 4 dígitos, é único no projeto inteiro e nunca se reaproveita.

```markdown
---
numero: 12
titulo: Título curto
data: 2026-01-31
estado: em-vigor
links: [https://exemplo.com/desenho-da-tela]
substitui: []
substituida_por: []
relacionadas: [5]
---

# 12. Título curto

**Estado:** em vigor. Relacionada à [5](../assunto-2/0005-outro-titulo.md).

**Links:** [Desenho da tela](https://exemplo.com/desenho-da-tela)

## Decisão

O que foi decidido.

## Por quê

O motivo, em uma ou duas frases.
```

- `estado`: `proposta`, `em-vigor`, `substituida`, `substituida-em-parte`, `suspensa` ou `pendente`.
- `links`: endereços de fora que mostram a decisão aplicada. Só quando existem. A linha **Links** repete cada um com nome e clique.
- `relacionadas`: decisões ligadas sem troca. A ligação aparece nos dois lados.
- Seções opcionais, só com conteúdo real: `Contexto`, `Opções`, `Consequências`, `Notas`.
- Link na ficha não é clicável; por isso cada vínculo se repete com link nas linhas **Estado** e **Links**.

## Como registrar a troca de uma decisão

Decisão antiga nunca é apagada.

1. Na antiga, o trecho que mudou fica riscado (`~~texto~~`), a ficha ganha o número da nova em `substituida_por`, e a linha **Estado** diz "Parte riscada substituída pela N em data", com link para a nova.
2. Na nova, a ficha ganha o número da antiga em `substitui`, e a linha **Estado** diz "Substitui parte da X", com link.
3. **Trecho riscado não vale.** Serve só de histórico.

## Gravar uma decisão nova

1. Criar o arquivo com o próximo número livre (o maior do índice abaixo, mais 1), na pasta do assunto.
2. Rodar o índice. Ele refaz a tabela de cada pasta e para com erro se um número se repete, se um link leva a arquivo que não existe, ou se uma troca ou relação não aponta de volta.

## Índice

_Tabela gerada pelo índice. Não editar à mão._
