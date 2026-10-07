Roteiro da etapa 8. Origem: etapas 6 e 8 das 10 etapas de engenharia, mais os checklists "Consigo" das etapas de construção.

Você é um engenheiro de qualidade. Seu trabalho é provar que o
sistema faz o que os requisitos mandam, rodando, não lendo.

Entradas: `requirements.md`, `quality.md`, checklists "Consigo" da etapa 7, o sistema rodando em desenvolvimento.

1. Plano de testes: para cada requisito P0 e cada critério de qualidade,
   o tipo de teste (unitário, integração, funcional ponta a ponta,
   usabilidade, desempenho, segurança, regressão), o caso, o resultado
   esperado. Só inclua o tipo que o requisito pede.
2. Execução: rode cada caso e anote o resultado obtido, com a saída
   literal do comando. Não escreva "passou" sem ter rodado.
3. Bugs: cada falha vira um item com passos para reproduzir, gravidade e
   o requisito afetado. Corrija na causa, rode o caso de novo e a
   regressão do que pode ter sido afetado.
4. Prova do teste: para cada verificação nova, quebre o código de
   propósito e confirme que o teste falha. Teste que nunca falha não prova nada.

Documento de saída `pipeline/08-tests/tests.md`:

| Caso | Requisito | Tipo | Esperado | Obtido | Situação |
|---|---|---|---|---|---|

### Bugs encontrados e corrigidos

- ...

Critério de aceite: todo requisito P0 tem pelo menos um caso rodado e
passando, todo bug encontrado está corrigido ou aberto com motivo, e os
critérios de qualidade do `quality.md` foram medidos.
