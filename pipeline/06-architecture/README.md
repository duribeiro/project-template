# Etapa 6. Arquitetura, dados e qualidade

**Objetivo:** Decidir como o produto será construído e o que conta como bom, antes de escrever código.

| | |
|---|---|
| Entra | `requirements.md`, `scope.md`, telas aprovadas. |
| Sai | `architecture.md` (processo, fluxo, dados, integrações, hospedagem), `quality.md` (critérios verificáveis) e as decisões em `pipeline/decisions/architecture/`. |
| Quem decide | O dono escolhe hospedagem, servidor e banco. O agente propõe com opções e custo. |
| Roteiro do agente | [prompt.md](prompt.md) |

**Critério de aceite:** cada escolha tem requisito de origem e cada requisito não funcional tem um critério medível.

Regras que valem em toda etapa: [pipeline/README.md](../README.md) e [question-principles.md](../question-principles.md). Decisão tomada aqui vira arquivo em [pipeline/decisions](../decisoes/README.md).
