---
name: adr
description: Records project decisions as ADRs (Architecture Decision Records) in lean MADR format - one Markdown file per decision, grouped in subject folders, with a generated and cross-checked index. Use it whenever a project decision is made, changed or reverted in the conversation, even if nobody asks for it. Triggers include "we decided", "let's go with", "from now on", "I changed my mind", "this replaces", "approved", "dropped", "record this decision", "ADR", and in Portuguese "decidi", "vamos fazer assim", "fica assim", "mudei de ideia", "isso substitui", "aprovado", "descartei", "a regra agora é", "registra essa decisão". Also use it to set up a decision log, to check what was already decided before proposing something, and to migrate decisions out of a table or a single document.
---

# ADR: registro de decisões

Uma decisão por arquivo, em pastas por assunto, com um índice em tabela em cada pasta. O agente lê a ficha de cada arquivo; a pessoa navega pelos links. Nenhuma decisão se apaga: a troca fica registrada nos dois lados.

## Requisitos

Nada é obrigatório. Com as ferramentas abaixo, o trabalho fica automático e conferido.

| O quê | Para quê | Conferir | Instalar |
|---|---|---|---|
| Um motor de JavaScript: Node.js 18 ou mais novo (preferido), Bun ou Deno | rodar o programa do índice. JavaScript fora do navegador precisa de um motor instalado | `node --version` (ou `bun --version`, `deno --version`) | Windows: `winget install OpenJS.NodeJS.LTS`. macOS: `brew install node`. Linux: gerenciador de pacotes da distribuição. Ou o instalador de nodejs.org |
| Git | só na migração, para achar a data de uma decisão que não tem data escrita | `git --version` | Windows: `winget install Git.Git`. macOS: `xcode-select --install`. Linux: gerenciador de pacotes. Ou git-scm.com |

- Antes do primeiro uso num projeto, rodar os comandos da coluna "Conferir".
- Faltando o motor, oferecer ao usuário o comando de instalar do sistema dele. Nunca instalar sem o sim.
- Sem motor nenhum, o agente faz à mão o que o programa faria: monta a tabela de cada `README.md` abaixo de `## Índice` e confere as regras da seção "Índice". Avisar o usuário que a conferência foi manual.

## Estrutura

```
<pasta de decisões>/
├── README.md              texto livre em cima: formato e regras; embaixo, título "Índice" e tabela gerada
├── <assunto-1>/
│   ├── README.md          título e uma frase do que o assunto cobre; embaixo, "Índice" gerado
│   └── 0001-titulo-curto.md
├── <assunto-2>/
│   └── <subassunto>/      subpasta quando um assunto cresce (ex.: uma por tela)
└── ...
```

- Os assuntos saem do projeto, não desta skill. Exemplos: `regras-de-negocio`, `arquitetura`, `interface`, `dados`, `seguranca`, `processo-de-trabalho`.
- Pastas nascem sob demanda: a pasta de um assunto é criada junto com a primeira decisão dele. Não criar pastas vazias nem pedir a lista de assuntos de antemão.
- Nome de pasta: descritivo, minúsculo, sem acento, sem número na frente. Número só quando a ordem importa e vem de fora (ex.: telas numeradas de um arquivo de desenho: `01-inicio`, `02-produto`).
- Toda pasta com decisões tem `README.md`. Pasta nova ganha índice sozinha ao rodar o programa.

## Arquivo de decisão

Nome `NNNN-titulo-curto.md`: número de 4 dígitos, único no projeto inteiro, nunca reaproveitado; título curto, minúsculo, sem acento, com hífen.

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

**Estado:** em vigor. Relacionada à [5](../outro-assunto/0005-outro-titulo.md).

**Links:** [Desenho da tela](https://exemplo.com/desenho-da-tela)

## Decisão

O que foi decidido.

## Por quê

O motivo, em uma ou duas frases.
```

Ficha:

- `estado`: `proposta`, `em-vigor`, `substituida`, `substituida-em-parte`, `suspensa` ou `pendente`. Estado novo só entra se o usuário decidir, e junto com a mudança no programa do índice, que recusa estado fora da lista.
- `data`: a data em que a decisão foi tomada, no formato AAAA-MM-DD.
- `links`: endereços de fora do registro que mostram a decisão aplicada (desenho, página, chamado, documento). Só quando existem. A linha **Links** no corpo repete cada um com nome e clique.
- `substitui`, `substituida_por`, `relacionadas`: números de outras decisões. Ver "Ligar decisões".
- `numero_antigo`: só quando uma migração precisou renumerar.

Corpo:

- Obrigatórias: `Decisão`; em decisão nova, também `Por quê`.
- Opcionais, só com conteúdo real: `Contexto`, `Opções`, `Consequências`, `Notas`. Seção vazia não entra. Nada de encher.

## Regras de escrita que valem para todo leitor

Os arquivos precisam funcionar igual no GitHub, no VS Code, no Obsidian e em visualizadores de chat de IA.

- Link sempre em Markdown: `[texto](caminho/relativo.md)` para arquivo do projeto, `[texto](https://...)` para a web. Nunca `[[wiki link]]`.
- Sem HTML: nem âncora (`<a id>`), nem comentário (`<!-- -->`). Há visualizadores que mostram HTML como texto cru.
- Link na ficha não é clicável em nenhum leitor. Todo número ou endereço da ficha se repete com link no corpo (linhas **Estado** e **Links**).

## Ligar decisões

Duas decisões se ligam de um jeito só:

| Caso | Na antiga (ou na primeira) | Na nova (ou na segunda) |
|---|---|---|
| A nova troca a antiga, inteira ou em parte | `substituida_por: [N]` | `substitui: [X]` |
| Ligadas sem troca: uma completa, cita ou depende da outra | `relacionadas: [N]` | `relacionadas: [X]` |

Trocar uma decisão (nunca apagar):

1. Na antiga, riscar só o trecho que mudou (`~~texto~~`) e mudar o estado para `substituida` (tudo riscado) ou `substituida-em-parte`. Linha Estado: "Parte riscada substituída pela [N](caminho) em DD/MM/AAAA: o que mudou."
2. Na nova, linha Estado: "Substitui parte da [X](caminho)." (ou "Substitui a [X]").
3. Trecho riscado não vale; fica só como histórico.

Relacionar: pôr o número nos dois lados e um link clicável nos dois corpos ("Relacionada à [N](caminho).").

## Índice

O programa `scripts/decisions-index.mjs`, dentro da pasta desta skill, faz duas coisas:

1. Em cada `README.md`, refaz tudo que vem abaixo do título `## Índice`: uma linha de aviso ("Tabela gerada pelo índice. Não editar à mão.") e a tabela com número (link), título, estado, pasta (quando há subpastas) e data. Tudo acima do título é texto livre e não é tocado. README sem o título ganha um no fim.
2. Não grava nada e sai com código 1 se: falta na ficha um dos campos `numero`, `titulo`, `data`, `estado`, `substitui`, `substituida_por` ou `relacionadas` (`links` só existe quando há endereço de fora); o título está vazio; a data não está no formato `AAAA-MM-DD`; um número se repete; o número da ficha difere do nome do arquivo; o estado não é um dos seis; `substitui`, `substituida_por` ou `relacionadas` não aponta de volta do outro lado; um link `.md` de decisão, ou do texto livre de um README, leva a arquivo que não existe. A tabela gerada não entra na conferência, porque é refeita a cada rodada: assim, mover uma decisão de pasta não trava o índice.

Código 2: pasta errada (sem `README.md`) ou falha ao ler ou gravar arquivo. Código 0: índices gravados.

Rodar depois de toda gravação, a partir da raiz do projeto:

```bash
node <pasta-desta-skill>/scripts/decisions-index.mjs <pasta-de-decisoes>
```

Com Bun, trocar `node` por `bun` (testado: mesmo resultado). Com Deno, `deno run --allow-read --allow-write` deve funcionar, porque o programa só usa `node:fs` e `node:path`, mas ainda não foi testado.

Se o projeto tem `package.json`, sugerir ao usuário copiar o programa para o projeto e criar um atalho, por exemplo `"decisoes": "node scripts/decisions-index.mjs docs/decisoes"`.

## Quando uma decisão aparece na conversa

1. Confirmar com o usuário o texto da decisão em uma ou duas frases, e o motivo. Não gravar decisão que o usuário não confirmou.
2. Procurar no índice se ela troca ou se liga a alguma decisão existente.
3. Gravar o arquivo com o próximo número livre (o maior do índice da raiz, mais 1), na pasta do assunto.
4. Atualizar os dois lados de cada ligação.
5. Rodar o índice e mostrar a saída.

Se mais de um agente grava no mesmo projeto ao mesmo tempo, combinar o número antes de gravar.

## Começar o registro num projeto

Três casos:

- **Projeto novo, sem decisões ainda:** criar só a pasta de decisões e o `README.md` da raiz, a partir de `modelo-README.md` (nesta skill), com a tabela de pastas vazia. As pastas de assunto nascem com a primeira decisão de cada uma.
- **Projeto que já tem decisões espalhadas** (documentos, atas, comentários, tabelas): ler os documentos, listar para o usuário as decisões encontradas, com a fonte de cada uma, e gravar só as que ele confirmar. Os assuntos saem do que foi encontrado. Seguir "Migrar de uma tabela ou de um documento único".
- **Registro que cresce aos poucos:** a cada decisão nova, seguir "Quando uma decisão aparece na conversa". Criar pasta nova quando aparecer assunto novo, e pôr a pasta na tabela de pastas do `README.md` da raiz.

Em todos os casos: perguntar ao usuário onde fica a pasta de decisões, se ainda não existe; conferir os requisitos; e registrar no guia de agentes do projeto (AGENTS.md, CLAUDE.md ou equivalente) onde vivem as decisões, que trecho riscado não vale, que decisão nova se grava com o índice rodando, e que decisão citada leva link para o arquivo.

## Migrar de uma tabela ou de um documento único

Cada item de origem vira um arquivo. O agente interpreta o conteúdo; não depende do nome das colunas.

- **O que foi decidido** vai para `Decisão`, copiado sem reescrever.
- **O motivo**, se estiver escrito em algum lugar do item, vai para `Por quê`. Se não estiver, a seção não entra. Nunca inventar motivo.
- **O registro** (quando, quem decidiu, observações, estado de andamento) vai para `Notas` e para a ficha (`data`, `estado`).
- **Referências** de fora (desenhos, páginas, chamados) vão para `links`.
- Item que diz ter sido trocado por outro vira `substituida_por` e `substitui`, nos dois lados.
- Título curto de cada decisão escrito à mão, não gerado das primeiras palavras.
- Data: a da decisão, não a da migração. Sem data escrita e com Git no projeto, medir com `git log --reverse -S "trecho do texto"` e dizer em `Notas` de onde veio a data.
- Números repetidos na origem ganham números novos no fim da fila, com `numero_antigo`.
- Conferir no fim: itens lidos = arquivos escritos, e o índice com 0 erros.
- O documento antigo vira um aviso curto que aponta para a pasta nova.

## Ao citar uma decisão

No chat e em documento, toda decisão citada leva link para o arquivo dela, por exemplo `[12](decisoes/interface/0012-titulo-curto.md)`. Nunca só o número: a pessoa não sabe em que pasta ela está.
