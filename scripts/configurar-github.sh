#!/usr/bin/env bash
# Configura no GitHub o que o modelo nao carrega: protecao da main, regras de merge,
# seguranca, etiquetas e permissoes das Actions. Pode rodar mais de uma vez.
#
# Requisitos: gh logado (gh auth status), repositorio ja criado no GitHub, branch main ja enviada.
# Uso: bash scripts/configurar-github.sh
# Variaveis opcionais:
#   APROVACOES=0   quantas aprovacoes humanas a main exige (0 para projeto solo, 1 para projeto aberto)
#   CHECKS="build scan ai-review"   conferencias obrigatorias
set -uo pipefail

APROVACOES="${APROVACOES:-0}"
CHECKS="${CHECKS:-build scan ai-review}"

if ! gh auth status >/dev/null 2>&1; then
  echo "gh nao esta logado. Rode: gh auth login" >&2
  exit 1
fi

repo="$(gh repo view --json nameWithOwner --jq .nameWithOwner)" || { echo "Nao achei o repositorio. Rode dentro da pasta do projeto, depois de criar e enviar." >&2; exit 1; }
privado="$(gh repo view --json isPrivate --jq .isPrivate)"
echo "Repositorio: $repo (privado: $privado). Aprovacoes humanas na main: $APROVACOES"

falhas=0
tenta() {
  local descricao="$1"; shift
  if "$@" >/dev/null 2>&1; then
    echo "  ok      $descricao"
  else
    echo "  FALHOU  $descricao"
    falhas=$((falhas + 1))
  fi
}

echo "1. Regras de merge"
tenta "so squash, junta sozinho quando liberado, apaga a branch depois" \
  gh api -X PATCH "repos/$repo" \
    -F allow_squash_merge=true -F allow_merge_commit=false -F allow_rebase_merge=false \
    -F allow_auto_merge=true -F delete_branch_on_merge=true \
    -f squash_merge_commit_title=PR_TITLE -f squash_merge_commit_message=PR_BODY

echo "2. Protecao da main"
contexts_json=""
for c in $CHECKS; do contexts_json="${contexts_json:+$contexts_json,}\"$c\""; done
arquivo_protecao="$(mktemp)"
cat > "$arquivo_protecao" <<EOF
{
  "required_status_checks": {"strict": true, "contexts": [$contexts_json]},
  "enforce_admins": true,
  "required_pull_request_reviews": {"required_approving_review_count": $APROVACOES, "dismiss_stale_reviews": true},
  "restrictions": null,
  "required_linear_history": true,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_conversation_resolution": true
}
EOF
tenta "main protegida: conferencias ($CHECKS), historia linear, sem force push, vale para o dono tambem" \
  gh api -X PUT "repos/$repo/branches/main/protection" --input "$arquivo_protecao"
rm -f "$arquivo_protecao"

echo "3. Seguranca"
tenta "alertas de dependencia vulneravel" gh api -X PUT "repos/$repo/vulnerability-alerts"
tenta "correcao automatica de dependencia vulneravel" gh api -X PUT "repos/$repo/automated-security-fixes"
tenta "varredura de segredo e bloqueio de push com segredo" \
  gh api -X PATCH "repos/$repo" \
    -f 'security_and_analysis[secret_scanning][status]=enabled' \
    -f 'security_and_analysis[secret_scanning_push_protection][status]=enabled'
tenta "relato privado de vulnerabilidade" gh api -X PUT "repos/$repo/private-vulnerability-reporting"

echo "4. Actions"
tenta "permissao padrao so de leitura, Actions nao aprova pedido" \
  gh api -X PUT "repos/$repo/actions/permissions/workflow" -f default_workflow_permissions=read -F can_approve_pull_request_reviews=false
tenta "pedido de fork de gente de fora espera aprovacao antes de rodar" \
  gh api -X PUT "repos/$repo/actions/permissions/fork-pr-contributor-approval" -f approval_policy=all_external_contributors

echo "5. Etiquetas"
tenta "etiqueta liberado" gh label create liberado --color 0E8A16 --description "Pessoa liberou o pedido apos a IA pedir analise" --force

echo "6. Conferencia (leitura do que ficou)"
gh api "repos/$repo/branches/main/protection" --jq '"  checks obrigatorios: \(.required_status_checks.contexts | join(", "))\n  aprovacoes exigidas: \(.required_pull_request_reviews.required_approving_review_count)\n  vale para admin: \(.enforce_admins.enabled)\n  historia linear: \(.required_linear_history.enabled)"' 2>/dev/null || echo "  nao consegui ler a protecao (a main ja foi enviada?)"

echo
echo "O que so voce pode fazer (nenhum segredo passa por este script):"
echo "  a) Token da revisao por IA:   gh secret set CLAUDE_CODE_OAUTH_TOKEN"
echo "  b) Se publicar na Cloudflare: veja infra/cloudflare/LEIA-ME.md"
echo "  c) Licenca: troque o texto do arquivo LICENSE antes de tornar o repositorio publico."

if [ "$falhas" -gt 0 ]; then
  echo
  echo "$falhas passo(s) falharam. Causas comuns: repositorio privado em plano gratuito (protecao e varredura de segredo exigem plano pago ou repositorio publico), ou a main ainda nao foi enviada." >&2
  exit 2
fi
