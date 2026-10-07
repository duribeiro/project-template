# Como contribuir

As regras completas de trabalho estão em [AGENTS.md](AGENTS.md). Este arquivo resume o caminho de uma mudança até a `main`.

## Caminho de uma mudança

Toda mudança passa por três conferências.

1. **Revisão local, antes de enviar.** Quem fez a mudança revisa junto com o agente, na própria máquina. No Claude Code, o comando é `/code-review`. `npm run lint` e `npm test` precisam passar.
2. **Revisão por IA no GitHub.** Ao abrir o pedido de junção, uma IA revisa a mudança, comenta nos pontos do código e dá um veredito: aprovado ou precisa de análise.
3. **Junção automática.** Se a IA aprovar, o GitHub junta sozinho, mas só depois que a conferência de montagem (`build`) e o procurador de segredo (`scan`) ficarem verdes.

A revisão por IA é conferência obrigatória, junto com `build` e `scan`. Commit novo num pedido já aprovado volta a esperar a IA revisar.

Se a IA pedir análise, a conferência dela fica vermelha e nada é juntado. Uma pessoa lê os comentários e decide: corrige e envia de novo, ou coloca a etiqueta `human-approved` no pedido e junta à mão. A etiqueta libera só o commit que estava no pedido quando ela foi colocada.

Comentário de revisão aberto também segura a junção. Responda e marque como resolvido.

## Quem de fora quer contribuir

1. Abra uma issue descrevendo a mudança antes de escrever código.
2. Faça um fork, crie uma branch curta e abra o pedido de junção para a `main`.
3. Nos pedidos vindos de fork, o GitHub não entrega o token da revisão por IA. A conferência `ai-review` fica vermelha e uma pessoa mantenedora revisa e junta à mão. Isso é esperado.
4. Ninguém de fora envia direto para a `main`. A proteção do repositório impede isso.

O robô de dependências abre no máximo três pedidos por semana, toda segunda às 6h. As atualizações pequenas entram sozinhas depois da aprovação da IA, e as de versão maior esperam uma pessoa. Correção de falha de segurança chega na hora, fora da agenda.

## Branches e publicação

- Toda mudança nasce numa branch curta criada a partir da `main`, com nome que diga o que ela faz (ex.: `feat/rota-de-produtos`).
- O pedido de junção vai sempre para a `main`. A branch curta é apagada depois da junção.
- Ninguém envia direto para a `main`, nem o dono do repositório.
- A publicação, quando o projeto tiver uma, está descrita em `infra/`. O modelo traz o exemplo para a Cloudflare em `infra/cloudflare/`.

## Convenções

- Código em inglês, sem comentário dentro do arquivo. O porquê fica na documentação.
- Texto que o cliente lê, em português do Brasil.
- Sem travessão nem traço médio em nenhum texto.
- Nenhum valor de segredo em arquivo. As chaves vivem no cofre.

## Versões

O número segue o [versionamento semântico](https://semver.org/lang/pt-BR/) e começa em 0.0.1.

- Correção, sem nada novo para quem usa: sobe o último número (0.1.0 vira 0.1.1).
- Funcionalidade nova: sobe o número do meio e zera o último (0.1.1 vira 0.2.0).
- 1.0.0 é quando o produto está no ar para quem ele foi feito.

Cada versão lançada ganha uma marca no GitHub (`v0.0.1`), uma página de lançamento e uma seção no [CHANGELOG.md](CHANGELOG.md).

## Mensagens de commit

[Conventional Commits](https://www.conventionalcommits.org/pt-br/v1.0.0/), em inglês: `type(scope): subject`.

```
feat(server): port the products route
fix(admin): redirect to login without a session
docs(infra): record the database diff
```
