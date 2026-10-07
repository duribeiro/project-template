Roteiro da etapa 7b. Origem: prompt 7 (construir tabelas) do time-de-agentes. O banco não vem fixo: ele sai da decisão da etapa 6.

Antes de construir: abra uma mudança no OpenSpec (`/opsx:propose`). Ambiente de baixo nunca aponta para produção. Chave e senha vêm do cofre.

---

Agora vamos dar memória permanente a este aplicativo, conectando um
banco de dados. Até aqui as telas usam dados de exemplo fixos. Vamos
trocar esses dados de mentira por dados reais, guardados de verdade.

O QUE EU QUERO

- Conectar o banco escolhido na etapa 6 (veja `esteira/06-arquitetura/arquitetura.md`) a este projeto.
- Olhar as telas que já existem e, a partir dos dados que elas mostram
  e recebem, criar as tabelas necessárias pra guardar esses dados.
- Fazer as telas lerem e gravarem nesse banco, no lugar dos dados de
  exemplo fixos.

REGRAS

- Crie uma tabela pra cada tipo de coisa que o app guarda, com uma
  coluna pra cada informação. Use nomes claros.
- Quando um dado pertence a outro, ligue as tabelas. Por exemplo, se
  cada manutenção pertence a um veículo, a manutenção deve estar
  associada ao veículo a que se refere.
- Troque todos os dados de exemplo fixos das telas pelos dados que vêm
  do banco. O que eu cadastrar deve ser gravado, e o que já estiver
  gravado deve aparecer ao abrir a tela.
- Não mexa em login nem em controle de acesso agora. Isso é um passo
  futuro. Por enquanto, os dados podem ser compartilhados, sem dono.

AO TERMINAR
Liste, em formato de checklist, os critérios de aceite. Cada item
começa com "Consigo" e descreve uma verificação testável. Inclua pelo
menos: consigo cadastrar um item e, ao recarregar a página, ele
continua lá.
