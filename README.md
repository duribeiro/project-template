# project-template

Modelo de repositório para começar um projeto já pronto para rodar a esteira de 9 etapas. Ele traz as regras do agente, a esteira com o roteiro de cada etapa, o OpenSpec, o registro de decisões, as conferências do GitHub (build, varredura de segredo, revisão por IA) e os scripts que configuram o GitHub.

## Criar um projeto novo

```
 [1. Botão "Use this template" no GitHub]   (ou: gh repo create NOME --template duribeiro/project-template --private)
          │
          ▼
 [2. Clonar e abrir a pasta]
          │
          ▼ (preenche nome, dono e descrição nos arquivos)
 [3. bash scripts/iniciar-projeto.sh NOME USUARIO "descrição"]
          │
          ▼ (commit e push da main; depois configura o GitHub)
 [4. bash scripts/configurar-github.sh]
          │
          ▼ (você: gh secret set CLAUDE_CODE_OAUTH_TOKEN)
 [5. Abrir o agente e começar pela etapa 1 da esteira]
```

Comandos do passo 2 ao 4:

```bash
gh repo create NOME --template duribeiro/project-template --private --clone
cd NOME
bash scripts/iniciar-projeto.sh NOME SEU-USUARIO "Frase do que o projeto é"
git add -A && git commit -m "chore: start project from template" && git push origin main
bash scripts/configurar-github.sh
gh secret set CLAUDE_CODE_OAUTH_TOKEN
```

A primeira volta de `git push origin main` é o único envio direto à `main`. Depois de `configurar-github.sh`, a `main` fica protegida.

## O que vem pronto

| Pasta ou arquivo | Para quê |
|---|---|
| `AGENTS.md`, `CLAUDE.md` | Regras do agente. `CLAUDE.md` só aponta para `AGENTS.md`, para Claude Code e OpenCode lerem o mesmo texto. |
| `esteira/` | As 9 etapas, cada uma com `README.md` e `prompt.md`, mais `ESTADO.md`, as regras de perguntas e a origem do método. |
| `esteira/decisoes/` | Registro de decisões, um arquivo por decisão, com índice gerado por `npm run decisoes`. |
| `openspec/` | Especificação antes de código. Comandos `/opsx:propose`, `/opsx:apply`, `/opsx:archive`. |
| `.claude/`, `.opencode/` | Skills e comandos do OpenSpec e a skill `adr`, para Claude Code e OpenCode. |
| `.github/` | Conferências, robô de dependências, revisão por IA, modelos de pedido e de issue, dono do código. |
| `scripts/` | `iniciar-projeto.sh` preenche os arquivos. `configurar-github.sh` aplica proteção da `main`, regras de merge e segurança. |
| `infra/cloudflare/` | Exemplo de publicação na Cloudflare, desligado. Leia o `LEIA-ME.md` ao decidir publicar. |
| `SECURITY.md`, `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `LICENSE` | Documentos de projeto aberto. A licença vem como espaço reservado e precisa ser escolhida. |

## O que o modelo não carrega

O GitHub não copia configuração de conta para o projeto novo. Por isso existe `scripts/configurar-github.sh`: proteção da `main`, regras de merge, alertas de segurança, etiquetas e permissões das Actions. Ele pode rodar mais de uma vez.

Exigem ação sua, porque envolvem segredo: o token da revisão por IA (`gh secret set CLAUDE_CODE_OAUTH_TOKEN`) e a ligação com o cofre e a Cloudflare.

## Projeto aberto ou fechado

- **Projeto solo:** `bash scripts/configurar-github.sh` (0 aprovações humanas, a revisão por IA decide).
- **Projeto aberto:** `APROVACOES=1 bash scripts/configurar-github.sh`. Em pedidos vindos de fork, o GitHub não entrega o token da revisão por IA e uma pessoa mantenedora revisa e junta à mão (explicado em `CONTRIBUTING.md`).
- Repositório privado em plano gratuito não aceita proteção de branch. O script avisa qual passo falhou.

## Limites conhecidos

- A pasta `.claude/skills/adr/scripts` e os comandos do OpenSpec vêm de outro projeto e funcionam sem alteração. A varredura de segredo usa o CLI do Infisical, que baixa pela internet a cada execução.
- O `ci.yml` usa `npm install` e roda `lint`, `test`, `typecheck` e `build` só se existirem no `package.json`. Ao criar o primeiro lockfile, troque para `npm ci`.
- Nenhuma tecnologia de aplicação vem decidida. Linguagem, banco e hospedagem saem da etapa 6.
