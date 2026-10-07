# Hospedagem: duas opções

Nenhuma está ligada. A etapa 6 da esteira (`pipeline/06-architecture`) decide qual usar, e a decisão vira arquivo em `pipeline/decisions/architecture/`. Cada pasta traz um guia, um exemplo de publicação pelo GitHub e a configuração da plataforma. Os arquivos terminam em `.example` para o GitHub não executá-los.

| | Cloudflare (Workers) | Vercel |
|---|---|---|
| Pasta | [cloudflare](cloudflare/README.md) | [vercel](vercel/README.md) |
| Serve | site estático e servidor no mesmo Worker | site e funções de servidor |
| Plano gratuito em projeto que vende | pode | não: o plano gratuito é só para uso não comercial (conferido em 20/09/2026, confirme de novo antes de decidir) |
| Domínio | precisa estar na conta Cloudflare | qualquer registrador |
| Chave de publicação | vem do cofre na hora, por OIDC | vem do cofre na hora, por OIDC |
| Publicação | `main` publica dev, versão `v*` publica produção | `main` publica dev, versão `v*` publica produção |

As duas usam o mesmo caminho para a chave: o GitHub prova quem é (OIDC), o cofre entrega a chave só na memória da publicação, e nenhuma chave fica guardada no GitHub.
