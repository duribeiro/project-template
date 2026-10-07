Roteiro da etapa 7c. Integrações com serviços de fora (pagamento, e-mail, entrega, outros), uma por vez, conforme `pipeline/06-architecture/architecture.md`.

Antes de construir: abra uma mudança no OpenSpec (`/opsx:propose`).

Para cada integração:

1. Leia a documentação do serviço e anote, em `pipeline/07-build/07c-integrations/README.md`, o que ele recebe, o que devolve e como falha.
2. Use a conta de teste do serviço. Nunca a de produção nesta etapa.
3. Toda chave vem do cofre. Aviso que chega de fora (webhook) só vale depois de conferir a assinatura dele.
4. Construa o caminho feliz e cada caso de falha que a documentação lista, com uma verificação rodável para cada um.
5. Registre decisões novas com a skill `adr`.

Ao terminar, liste em formato de checklist os critérios de aceite. Cada item começa com "Consigo" e descreve uma verificação testável, incluindo pelo menos um caso de falha do serviço de fora.
