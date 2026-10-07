# Etapa 7. Construção controlada

**Objetivo:** Construir com rastreabilidade: cada pedaço de código aponta para o requisito que cumpre.

| | |
|---|---|
| Entra | Requisitos, arquitetura, telas aprovadas e histórias de usuário. |
| Sai | Código nas três frentes (`07a-interface`, `07b-data`, `07c-integrations`), registro das decisões, mapa requisito para implementação e lista de pendências técnicas. |
| Quem decide | O agente constrói. O dono avalia o resultado construído, não as histórias. |
| Roteiro do agente | [prompt.md](prompt.md) |

**Critério de aceite:** cada requisito P0 tem código e uma verificação rodável, e as pendências técnicas estão listadas.

Cada frente abre mudanças no OpenSpec (`/opsx:propose`, `/opsx:apply`, `/opsx:archive`). O mapa requisito para implementação fica em `pipeline/07-build/traceability.md`.

Regras que valem em toda etapa: [pipeline/README.md](../README.md) e [question-principles.md](../question-principles.md). Decisão tomada aqui vira arquivo em [pipeline/decisions](../decisoes/README.md).
