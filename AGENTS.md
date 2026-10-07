# NOME-DO-PROJETO

Descreva em uma frase o que este projeto é e para quem. Preencha na primeira sessão, junto com `esteira/01-problema-e-visao`.

**Estado de hoje:** projeto recém-criado a partir do modelo `project-template`. Nada decidido ainda. A próxima ação está em `esteira/ESTADO.md`.

Trabalho em aberto vive no OpenSpec (`openspec/changes/`). Este arquivo só diz como se trabalha aqui.

## Como responder ao dono do projeto

**No máximo 5 a 10 linhas por resposta, contando tudo.** O dono decide rápido e não lê relatório longo.

- O resultado na primeira frase. Depois o que travou, se travou. No fim, uma pergunta só, se houver decisão para ele.
- Ele não vê o código, só o chat. Fale do efeito, não do mecanismo. Nomeie a coisa antes de usar o nome técnico dela.
- Português do Brasil, direto, simples para junior. Uma ideia por frase. Nada de analogia. Não justifique cada escolha.
- **Escreva direto, sem frase de efeito.** Fora: contraste ("não é X, é Y"), fechamento de impacto, fragmento dramático, palavra grandiosa, e frase construída em ritmo ou paralelismo. Cada frase entrega um fato, uma decisão ou um efeito. Vale também nos documentos, não só no chat.
- Sem travessão nem traço médio, em nenhum texto. Use ponto, vírgula, dois-pontos ou parênteses.
- Evidência detalhada fica nos arquivos. No chat vai só o número que importa, literal.
- Desenho com caixas e setas, tabela e título: só quando o dono pedir explicação, ou quando sem isso a decisão não dá para tomar.

## Como trabalhar

1. **Perguntar antes de agir.** Antes de ação com efeito colateral, reafirme o pedido em até 3 frases e faça de 1 a 3 perguntas que mudam o resultado. Dúvida não vira suposição. Ler e listar não pedem aprovação. Ação irreversível exige sinal verde explícito.
2. **Decisão dele se mostra antes de gravar.** Nenhuma decisão vai para arquivo antes de ele decidir. Mostre a proposta no chat, uma de cada vez, com um exemplo concreto do que acontece em cada opção. Só o que ele decidiu na conversa vale. **Documento e comentário antigos não são decisão:** entram como proposta sob suspeição, nunca como regra em vigor.
3. **Plano antes de executar.** Mudança não trivial começa com plano: por quê, onde, o quê, como validar, como reverter. Microtarefas pequenas o bastante para um modelo simples executar.
4. **Especificação antes de código.** Todo trabalho passa pelo OpenSpec: propor, especificar, implementar, arquivar. Atalhos: `/opsx:propose`, `/opsx:apply`, `/opsx:archive`. Código e especificação divergentes é defeito: levante, não escolha sozinho.
5. **O menor código que resolve.** Isso precisa existir? Já existe aqui? A plataforma já faz? Uma dependência instalada resolve? Sem abstração que ninguém pediu. Corrija a causa na função compartilhada, uma vez.
6. **Medir, não afirmar.** Nenhuma afirmação sobre o sistema sem rodar e ler a saída literal. Relatório de subagente é alegação. Tela só conta como entregue depois de aberta num navegador e usada. Prova nova só vale depois de você quebrar o código de propósito e vê-la cair.
7. **Não sobrescrever nem apagar o que você não criou.** Liste o alvo e olhe antes. Se existe e não foi você que criou, pergunte.
8. **Modelo pelo tamanho da tarefa.** Tarefa simples com modelo simples. Não gaste modelo forte em execução mecânica.
9. **Recomendar o caminho mais eficiente:** qual comando pronto, qual habilidade, qual modelo. Se nenhum se aplica, diga isso.

## A esteira

O projeto roda a esteira de 9 etapas, na pasta `esteira/`. Cada etapa tem uma pasta com `README.md` (o que entra, o que sai, quem decide, critério de aceite) e `prompt.md` (o roteiro que o agente segue). O índice e o estado estão em `esteira/README.md` e `esteira/ESTADO.md`. Leia o `ESTADO.md` antes de qualquer tarefa.

- O dono decide em três pontos: visão (etapa 1), wireframe (etapa 4) e entrega (etapa 9). Entre esses pontos o agente segue sozinho. As histórias de usuário não passam por aprovação prévia: o dono avalia o resultado construído.
- **Só perguntar o que precisa.** A pergunta sobe ao dono quando as três condições valem juntas: a resposta não está nos documentos aprovados, ela muda o resultado, e o agente não consegue medir nem pesquisar sozinho. Se faltar uma, o agente decide e registra.
- **Filtro contra excesso:** toda peça nova passa por "a primeira versão para sem isso?". Se não para, fica para depois.
- Etapa reprovada não volta: o card ganha tarefas de correção dentro dele.
- A esteira decide o quê e por quê. O OpenSpec guarda o como e o trabalho em aberto. Etapa que vira código abre mudança no OpenSpec.

## Decisões

- Cada decisão é um arquivo em `esteira/decisoes/`, no formato da skill `adr`. O índice se refaz com `npm run decisoes`.
- Decisão antiga nunca é apagada. Trecho riscado não vale: a linha Estado aponta a decisão que o substituiu.
- Decisão citada leva link para o arquivo dela, no chat e em documento, nunca só o número.

## Segredos

Toda chave, senha, usuário e conexão vive no cofre (Infisical, ou o que o projeto adotar). Nada disso fica em arquivo do projeto.

- O `.env` fica fora do git. `.env.example` só lista os nomes das variáveis.
- Variável nova nasce no cofre, no ambiente certo. Agente não lê valor de segredo para o chat, nem escreve valor em arquivo.
- A publicação entra no cofre com a identidade do próprio GitHub (OIDC). Nenhuma chave de publicação fica guardada no GitHub.
- Exceção conferida do procurador de segredo vive em `.infisical-scan.toml`, e cada linha dela precisa de motivo escrito.

## Commits e caminho até a `main`

Conventional Commits, em inglês: `type(scope): subject`. Subject minúsculo, imperativo, sem ponto final, até 72 caracteres. O corpo explica por quê. Um commit por mudança coerente.

**Ninguém envia direto para a `main`, nem o dono.** Cada tarefa cria uma branch curta a partir da `main` e abre o pedido de junção para a `main`. O caminho tem três conferências:

1. revisão local com o agente antes de enviar, pelo `/code-review`;
2. revisão por IA no GitHub, que comenta e dá o veredito;
3. se ela aprovar, o GitHub junta sozinho depois que `build` e `scan` ficarem verdes. Se ela pedir análise, nada é juntado e uma pessoa decide: corrige, ou põe a etiqueta `liberado` e junta à mão.

A revisão por IA é conferência obrigatória: commit novo depois da aprovação volta a esperar por ela. O robô de dependências segue o mesmo caminho, e salto de versão maior nunca entra sozinho. Pedido que mexe em `esteira/` só o dono junta.

## Regras que não se negociam

- **Segredo nunca entra no repositório, nem fica no disco.**
- **Ambiente de baixo nunca aponta para produção.**
- **Apagar dado é operação manual.** A chave da aplicação não tem permissão de apagar, de propósito.
- **Identificador interno nasce em inglês.** Campo de resposta, coluna de banco, variável de ambiente e chave de erro são contrato e não se renomeiam.
- **Todo código em inglês, sem comentário dentro do arquivo.** O porquê de cada função vive na documentação, não no código. Texto que o cliente lê fica em português, com acento.
- **Entregável nunca em `C:`.** Temporário vai para pasta temporária.

Regras próprias deste projeto (pagamento, dados pessoais, domínio) entram aqui quando forem decididas, cada uma com o link da decisão.
