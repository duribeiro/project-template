# project-template

[![Release](https://img.shields.io/github/v/release/duribeiro/project-template)](https://github.com/duribeiro/project-template/releases)
[![CI](https://github.com/duribeiro/project-template/actions/workflows/ci.yml/badge.svg)](https://github.com/duribeiro/project-template/actions/workflows/ci.yml)
[![Dependabot](https://img.shields.io/badge/dependabot-enabled-025e8c?logo=dependabot)](.github/dependabot.yml)
[![Conventional Commits](https://img.shields.io/badge/commits-conventional-fe5196)](https://www.conventionalcommits.org/pt-br/v1.0.0/)

Os selos de versão e de CI só aparecem para quem não tem acesso quando o repositório é público. Em repositório privado, a versão aparece na aba Releases.

Modelo de repositório para começar um projeto já pronto para rodar a esteira de 9 etapas. Ele traz as regras do agente, a esteira com o roteiro de cada etapa, o OpenSpec, o registro de decisões, as conferências do GitHub (build, varredura de segredo, revisão por IA) e os scripts que configuram o GitHub.

## Criar um projeto novo

```
 [1. Botão "Use this template" no GitHub]   (ou: gh repo create NOME --template duribeiro/project-template --private)
          │
          ▼
 [2. Clonar e abrir a pasta]
          │
          ▼ (preenche nome, dono e descrição nos arquivos)
 [3. bash scripts/init-project.sh NOME USUARIO "descrição"]
          │
          ▼ (commit e push da main; depois configura o GitHub)
 [4. bash scripts/configure-github.sh]
          │
          ▼ (você: gh secret set CLAUDE_CODE_OAUTH_TOKEN)
 [5. Abrir o agente e começar pela etapa 1 da esteira]
```

Comandos do passo 2 ao 4:

```bash
gh repo create NOME --template duribeiro/project-template --private --clone
cd NOME
bash scripts/init-project.sh NOME SEU-USUARIO "Frase do que o projeto é"
git add -A && git commit -m "chore: start project from template" && git push origin main
bash scripts/configure-github.sh
gh secret set CLAUDE_CODE_OAUTH_TOKEN
```

A primeira volta de `git push origin main` é o único envio direto à `main`. Depois de `configure-github.sh`, a `main` fica protegida.

## O que vem pronto

| Pasta ou arquivo | Para quê |
|---|---|
| `AGENTS.md`, `CLAUDE.md` | Regras do agente. `CLAUDE.md` só aponta para `AGENTS.md`, para Claude Code e OpenCode lerem o mesmo texto. |
| `pipeline/` | As 9 etapas, cada uma com `README.md` e `prompt.md`, mais `STATE.md`, as regras de perguntas e a origem do método. |
| `pipeline/decisions/` | Registro de decisões, um arquivo por decisão, com índice gerado por `npm run decisions`. |
| `openspec/` | Especificação antes de código. Comandos `/opsx:propose`, `/opsx:apply`, `/opsx:archive`. |
| `.claude/`, `.opencode/` | Skills e comandos do OpenSpec e a skill `adr`, para Claude Code e OpenCode. |
| `.github/` | Conferências, robô de dependências, revisão por IA, modelos de pedido e de issue, dono do código. |
| `scripts/` | `init-project.sh` preenche os arquivos. `configure-github.sh` aplica proteção da `main`, regras de merge e segurança. |
| `infra/` | Duas opções de hospedagem, Cloudflare ou Vercel, desligadas. A etapa 6 decide. Comparação em `infra/README.md`. |
| `SECURITY.md`, `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `LICENSE` | Documentos de projeto aberto. A licença vem como espaço reservado e precisa ser escolhida. |

## O que o modelo não carrega

O GitHub não copia configuração de conta para o projeto novo. Por isso existe `scripts/configure-github.sh`: proteção da `main`, regras de merge, alertas de segurança, etiquetas e permissões das Actions. Ele pode rodar mais de uma vez.

Exigem ação sua, porque envolvem segredo: o token da revisão por IA (`gh secret set CLAUDE_CODE_OAUTH_TOKEN`) e a ligação com o cofre e com a hospedagem escolhida.

## Projeto aberto ou fechado

- **Projeto solo:** `bash scripts/configure-github.sh` (0 aprovações humanas, a revisão por IA decide).
- **Projeto aberto:** `APPROVALS=1 bash scripts/configure-github.sh`. Em pedidos vindos de fork, o GitHub não entrega o token da revisão por IA e uma pessoa mantenedora revisa e junta à mão (explicado em `CONTRIBUTING.md`).
- Repositório privado em plano gratuito não aceita proteção de branch. O script avisa qual passo falhou.

## Versão

Todo projeto nasce na versão **0.0.1**, seguindo o versionamento semântico descrito em `CONTRIBUTING.md`. O `CHANGELOG.md` já traz a seção 0.0.1, `init-project.sh` coloca a data de hoje nela, e `configure-github.sh` cria a release `v0.0.1` no GitHub.

## Limites conhecidos

- A pasta `.claude/skills/adr/scripts` e os comandos do OpenSpec vêm de outro projeto e funcionam sem alteração. A varredura de segredo usa o CLI do Infisical, que baixa pela internet a cada execução.
- O `ci.yml` usa `npm install` e roda `lint`, `test`, `typecheck` e `build` só se existirem no `package.json`. Ao criar o primeiro lockfile, troque para `npm ci`.
- Nenhuma tecnologia de aplicação vem decidida. Linguagem, banco e hospedagem saem da etapa 6.
