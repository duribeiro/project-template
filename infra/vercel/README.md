# Publicar na Vercel

Esta pasta é um exemplo, não está ligada. Use quando a etapa 6 da esteira decidir publicar na Vercel. Antes, confira o plano: o gratuito da Vercel é só para uso não comercial. Comparação com a outra opção em [infra/README.md](../README.md).

## Arquivos

| Arquivo | Função |
|---|---|
| `vercel.json.example` | Diz à Vercel como montar o site (comando, pasta de saída) e como tratar rotas de página única. Copie para a raiz como `vercel.json`. |
| `deploy.yml.example` | Publicação pelo GitHub: entrar na `main` publica o desenvolvimento (preview), criar uma versão `v*` publica a produção. Copie para `.github/workflows/deploy.yml`. |

## Como a chave chega sem ficar guardada no GitHub

```
 [Push na main, ou versão v* publicada]
          │
          ▼ (o GitHub emite uma identidade temporária, OIDC)
 [Cofre Infisical confere a identidade]
          │
          ▼ (devolve VERCEL_TOKEN, VERCEL_ORG_ID e VERCEL_PROJECT_ID, só na memória)
 [vercel pull, build e deploy]
```

## O que só o dono faz, uma vez por projeto

1. Criar o projeto na Vercel (`npx vercel link`) e anotar o identificador da organização e do projeto.
2. No cofre, guardar `VERCEL_TOKEN`, `VERCEL_ORG_ID` e `VERCEL_PROJECT_ID` no ambiente `prod`, e criar a identidade que aceita o GitHub (OIDC).
3. No GitHub: `gh variable set INFISICAL_IDENTITY_ID` com o identificador dessa identidade.
4. Em `deploy.yml`, trocar `<ID-DO-PROJETO-NO-COFRE>` e `<URL-DO-COFRE>`.
5. Desligar a publicação automática da própria Vercel pelo Git (Settings, Git), para o GitHub ser o único caminho.

Registre a escolha como decisão antes de ligar qualquer arquivo daqui.
