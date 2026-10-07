# A esteira de 9 etapas

Método unificado de 7 prompts de entrevista de produto e 10 etapas de engenharia de qualidade (mapa e origem em [origem-do-metodo.md](origem-do-metodo.md)). Cada etapa tem uma pasta com `README.md` (o que entra, o que sai, quem decide, critério de aceite) e `prompt.md` (o roteiro que o agente segue).

| Etapa | Pasta | Quem decide |
|---|---|---|
| 1. Problema e visão | [01-problema-e-visao](01-problema-e-visao/README.md) | dono aprova |
| 2. Jornadas | [02-jornadas](02-jornadas/README.md) | time |
| 3. Funcionalidades e corte do MVP | [03-corte-do-mvp](03-corte-do-mvp/README.md) | time |
| 4. Wireframe da jornada | [04-wireframe](04-wireframe/README.md) | dono aprova |
| 5. Requisitos tirados da tela | [05-requisitos](05-requisitos/README.md) | time, dono aprova a lista |
| 6. Arquitetura, dados e qualidade | [06-arquitetura](06-arquitetura/README.md) | dono escolhe hospedagem e banco |
| 7. Construção controlada | [07-construcao](07-construcao/README.md) | time; dono avalia o resultado |
| 8. Testes | [08-testes](08-testes/README.md) | time |
| 9. Entrega e homologação | [09-entrega](09-entrega/README.md) | dono valida |

O estado de cada etapa e o próximo passo ficam em [ESTADO.md](ESTADO.md).

## Como uma etapa roda

```
 [Agente lê ESTADO.md e o prompt.md da etapa]
          │
          ▼ (pergunta só o que passa nas 3 condições)
 [Entrevista ou trabalho, um assunto por vez]
          │
          ▼ (resultado mostrado no chat)
 [Dono decide]  ──(ajuste)──┐
          │                 │
          ▼ (aprovado)      │
 [Documento gravado na pasta da etapa] <─┘
          │
          ▼ (decisão que muda regra)
 [Arquivo em decisoes/ com a skill adr]
          │
          ▼
 [ESTADO.md atualizado, próxima etapa]
```

## Regras que valem em todas as etapas

- **O dono decide em três pontos:** visão (etapa 1), wireframe (etapa 4) e entrega (etapa 9). Entre eles o time segue sozinho, sem aprovação por microtarefa.
- **Só perguntar o que precisa:** [principios-de-perguntas.md](principios-de-perguntas.md).
- **Filtro contra excesso:** toda peça nova passa por "a primeira versão para sem isso?". Se não para, fica para depois.
- **Etapa reprovada não volta de coluna:** o card ganha tarefas de correção dentro dele.
- **A esteira decide o quê e por quê.** O OpenSpec (`openspec/changes/`) guarda o como e o trabalho em aberto. Etapa que vira código abre mudança no OpenSpec.
- **Decisão só se grava depois de o dono decidir**, no formato da skill `adr`, em [decisoes](decisoes/README.md).
