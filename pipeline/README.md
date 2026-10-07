# A esteira de 9 etapas

Método unificado de 7 prompts de entrevista de produto e 10 etapas de engenharia de qualidade (mapa e origem em [method-origin.md](method-origin.md)). Cada etapa tem uma pasta com `README.md` (o que entra, o que sai, quem decide, critério de aceite) e `prompt.md` (o roteiro que o agente segue).

| Etapa | Pasta | Quem decide |
|---|---|---|
| 1. Problema e visão | [01-problem-and-vision](01-problem-and-vision/README.md) | dono aprova |
| 2. Jornadas | [02-journeys](02-journeys/README.md) | time |
| 3. Funcionalidades e corte do MVP | [03-mvp-scope](03-mvp-scope/README.md) | time |
| 4. Wireframe da jornada | [04-wireframe](04-wireframe/README.md) | dono aprova |
| 5. Requisitos tirados da tela | [05-requirements](05-requirements/README.md) | time, dono aprova a lista |
| 6. Arquitetura, dados e qualidade | [06-architecture](06-architecture/README.md) | dono escolhe hospedagem e banco |
| 7. Construção controlada | [07-build](07-build/README.md) | time; dono avalia o resultado |
| 8. Testes | [08-tests](08-tests/README.md) | time |
| 9. Entrega e homologação | [09-delivery](09-delivery/README.md) | dono valida |

O estado de cada etapa e o próximo passo ficam em [STATE.md](STATE.md).

## Como uma etapa roda

```
 [Agente lê STATE.md e o prompt.md da etapa]
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
 [STATE.md atualizado, próxima etapa]
```

## Regras que valem em todas as etapas

- **O dono decide em três pontos:** visão (etapa 1), wireframe (etapa 4) e entrega (etapa 9). Entre eles o time segue sozinho, sem aprovação por microtarefa.
- **Só perguntar o que precisa:** [question-principles.md](question-principles.md).
- **Filtro contra excesso:** toda peça nova passa por "a primeira versão para sem isso?". Se não para, fica para depois.
- **Etapa reprovada não volta de coluna:** o card ganha tarefas de correção dentro dele.
- **A esteira decide o quê e por quê.** O OpenSpec (`openspec/changes/`) guarda o como e o trabalho em aberto. Etapa que vira código abre mudança no OpenSpec.
- **Decisão só se grava depois de o dono decidir**, no formato da skill `adr`, em [decisoes](decisoes/README.md).
