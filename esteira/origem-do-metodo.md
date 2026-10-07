# Origem do método

A esteira junta três fontes. Este arquivo existe para o roteiro de cada etapa nunca mais perder de onde veio.

| Fonte | O que é | Onde mora no disco do dono |
|---|---|---|
| 7 prompts de entrevista de produto | Visão, jornada, brainstorm, MVP, ideação de telas, criar tela, banco de dados | `D:/Windows-share/ribeiroedu/time-de-agentes/01-visao` a `07-construcao` |
| 10 etapas de engenharia de qualidade | Método do hackathon: problema, requisitos, validação, processo, modelagem, qualidade, construção, testes, entrega, manutenção | `D:/Windows-share/ribeiroedu/time-de-agentes/referencias/engenharia-10-etapas` |
| agent-engineer | Versão executável das 10 etapas (orquestrador, 5 subagentes, 57 skills). Usado só como biblioteca de consulta | `D:/Windows-share/agent-engineer/ai-engineering-workflow` |
ibeiroedu	ime-de-agentes
eferencias\engenharia-10-etapas` |
| agent-engineer | Versão executável das 10 etapas (orquestrador, 5 subagentes, 57 skills). Usado só como biblioteca de consulta | `D:\Windows-sharegent-engineeri-engineering-workflow` |

## Como as 17 peças (7 prompts e 10 etapas) viraram 9

| Etapa | 7 prompts | 10 etapas | Decisão |
|---|---|---|---|
| 1. Problema e visão | 1 visão | 1 entendimento do problema | juntar; a visão ganha riscos |
| 2. Jornadas | 2 jornada | histórias de usuário da 5 | juntar; as histórias sobem para cá |
| 3. Corte do MVP | 3 brainstorm, 4 MVP | 3 validação, 4 backlog P0/P1/P2 | uma etapa, uma escala |
| 4. Wireframe | 5 lista de telas | protótipo de telas da 5 | vem antes dos requisitos |
| 5. Requisitos tirados da tela | | 2 levantamento, checklist da 3 | entra do hackathon |
| 6. Arquitetura, dados e qualidade | | 4 processo, 5 modelagem, 6 qualidade | versão curta |
| 7. Construção controlada | 6 criar tela, 7 banco | 7 construção | os prompts 6 e 7 viram frentes 7a e 7b; 7c é integrações |
| 8. Testes | checklists "Consigo" | 8 testes e verificação | juntar |
| 9. Entrega e homologação | | 9 entrega | entra do hackathon |
| Depois da versão 1 | | 10 manutenção | fica para depois |

## Decisões que o método já traz

- Wireframe antes dos requisitos: os requisitos saem da tela aprovada.
- O dono decide em três pontos (visão, wireframe, entrega). As histórias de usuário não passam por aprovação prévia.
- Etapa reprovada não volta: o card ganha tarefas de correção. Isso substitui o "voltar de etapa" do agent-engineer.
- O banco e a hospedagem saem da etapa 6, não vêm fixos nos prompts.
