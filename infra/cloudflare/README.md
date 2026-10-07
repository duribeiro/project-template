# Publicar na Cloudflare

Esta pasta é um exemplo, não está ligada. Comparação com a outra opção (Vercel) em [infra/README.md](../README.md). Os arquivos terminam em `.example` para o GitHub não executá-los. Use quando a etapa 6 da esteira decidir publicar na Cloudflare (Workers com arquivos do site).

## O que cada arquivo faz

| Arquivo | Função |
|---|---|
| `wrangler.jsonc.example` | Define o Worker de desenvolvimento (domínio `dev.<seu-dominio>`) e o de produção. Copie para a raiz como `wrangler.jsonc` e troque os nomes entre `<>`. |
| `deploy.yml.example` | Publicação pelo GitHub: entrar na `main` publica o desenvolvimento, criar uma versão `v*` publica a produção. Copie para `.github/workflows/deploy.yml`. |

## Como a chave da Cloudflare chega sem ficar guardada no GitHub

```
 [Push na main, ou versão v* publicada]
          │
          ▼ (o GitHub emite uma identidade temporária, OIDC)
 [Cofre Infisical confere a identidade]
          │
          ▼ (devolve a chave da Cloudflare, só na memória do processo)
 [wrangler deploy publica o Worker]
```

Nenhum segredo da Cloudflare entra no GitHub. O único valor guardado lá é o identificador da identidade do cofre, como variável (não segredo).

## O que só o dono faz, uma vez por projeto

1. No cofre, criar a identidade que aceita o GitHub (OIDC) para este repositório e guardar a chave da Cloudflare no ambiente `prod`.
2. No GitHub: `gh variable set INFISICAL_IDENTITY_ID` com o identificador dessa identidade.
3. Em `deploy.yml`, trocar `<ID-DO-PROJETO-NO-COFRE>` e `<URL-DO-COFRE>`.
4. Em `wrangler.jsonc`, trocar os nomes e o domínio. O domínio precisa estar na conta Cloudflare do dono.
5. Acrescentar ao `ci.yml` os passos `npx wrangler deploy --dry-run` para ensaiar a publicação a cada pedido.

Registre a escolha como decisão em `pipeline/decisions/architecture/` antes de ligar qualquer arquivo daqui.
