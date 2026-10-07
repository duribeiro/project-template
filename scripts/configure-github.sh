#!/usr/bin/env bash
# Configura no GitHub o que o modelo nao carrega: protecao da main, regras de merge,
# seguranca, etiquetas, permissoes das Actions e a primeira versao (release v0.0.1).
# Pode rodar mais de uma vez.
#
# Requisitos: gh logado (gh auth status), repositorio ja criado no GitHub, branch main ja enviada.
# Uso: bash scripts/configure-github.sh
# Variaveis opcionais:
#   APPROVALS=0                     aprovacoes humanas que a main exige (0 projeto solo, 1 projeto aberto)
#   CHECKS="build scan ai-review"   conferencias obrigatorias
set -uo pipefail

APPROVALS="${APPROVALS:-0}"
CHECKS="${CHECKS:-build scan ai-review}"

if ! gh auth status >/dev/null 2>&1; then
  echo "gh nao esta logado. Rode: gh auth login" >&2
  exit 1
fi

repo="$(gh repo view --json nameWithOwner --jq .nameWithOwner)" || {
  echo "Nao achei o repositorio. Rode dentro da pasta do projeto, depois de criar e enviar." >&2
  exit 1
}
is_private="$(gh repo view --json isPrivate --jq .isPrivate)"
echo "Repositorio: $repo (privado: $is_private). Aprovacoes humanas na main: $APPROVALS"

failures=0
skip_step() {
  echo "  pulado  $1 (so existe em repositorio publico; rode de novo depois de tornar o repositorio publico)"
}
run_step() {
  local description="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "  ok      $description"
  else
    echo "  FALHOU  $description"
    failures=$((failures + 1))
  fi
}

echo "1. Regras de merge"
run_step "so squash, junta sozinho quando liberado, apaga a branch depois" \
  gh api -X PATCH "repos/$repo" \
    -F allow_squash_merge=true -F allow_merge_commit=false -F allow_rebase_merge=false \
    -F allow_auto_merge=true -F delete_branch_on_merge=true \
    -f squash_merge_commit_title=PR_TITLE -f squash_merge_commit_message=PR_BODY

echo "2. Protecao da main"
contexts_json=""
for check in $CHECKS; do
  contexts_json="${contexts_json:+$contexts_json,}\"$check\""
done
protection_file="$(mktemp)"
cat > "$protection_file" <<EOF
{
  "required_status_checks": {"strict": true, "contexts": [$contexts_json]},
  "enforce_admins": true,
  "required_pull_request_reviews": {"required_approving_review_count": $APPROVALS, "dismiss_stale_reviews": true},
  "restrictions": null,
  "required_linear_history": true,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_conversation_resolution": true
}
EOF
run_step "main protegida: conferencias ($CHECKS), historia linear, sem force push, vale para o dono tambem" \
  gh api -X PUT "repos/$repo/branches/main/protection" --input "$protection_file"
rm -f "$protection_file"

echo "3. Seguranca"
run_step "alertas de dependencia vulneravel" gh api -X PUT "repos/$repo/vulnerability-alerts"
run_step "correcao automatica de dependencia vulneravel" gh api -X PUT "repos/$repo/automated-security-fixes"
if [ "$is_private" = "true" ]; then
  skip_step "varredura de segredo e bloqueio de push com segredo"
  skip_step "relato privado de vulnerabilidade"
else
  run_step "varredura de segredo e bloqueio de push com segredo" \
    gh api -X PATCH "repos/$repo" \
      -f 'security_and_analysis[secret_scanning][status]=enabled' \
      -f 'security_and_analysis[secret_scanning_push_protection][status]=enabled'
  run_step "relato privado de vulnerabilidade" gh api -X PUT "repos/$repo/private-vulnerability-reporting"
fi

echo "4. Actions"
run_step "permissao padrao so de leitura, Actions nao aprova pedido" \
  gh api -X PUT "repos/$repo/actions/permissions/workflow" -f default_workflow_permissions=read -F can_approve_pull_request_reviews=false
if [ "$is_private" = "true" ]; then
  skip_step "pedido de fork de gente de fora espera aprovacao antes de rodar"
else
  run_step "pedido de fork de gente de fora espera aprovacao antes de rodar" \
    gh api -X PUT "repos/$repo/actions/permissions/fork-pr-contributor-approval" -f approval_policy=all_external_contributors
fi

echo "5. Etiquetas"
run_step "etiqueta human-approved" gh label create human-approved --color 0E8A16 --description "Pessoa liberou o pedido apos a IA pedir analise" --force

echo "6. Primeira versao"
version="$(grep -m1 '"version"' package.json | sed 's/.*: *"\(.*\)".*/\1/')"
if [ -n "$(gh release list --limit 1 --json tagName --jq '.[].tagName')" ]; then
  echo "  ok      o repositorio ja tem versao publicada, nada a criar"
else
  notes="$(sed -n "/^## \[$version\]/,/^## \[/p" CHANGELOG.md | sed '1d;$d')"
  run_step "release v$version a partir da main" \
    gh release create "v$version" --target main --title "v$version" --notes "${notes:-Primeira versao.}"
fi

echo "7. Conferencia (leitura do que ficou)"
gh api "repos/$repo/branches/main/protection" --jq '"  checks obrigatorios: \(.required_status_checks.contexts | join(", "))\n  aprovacoes exigidas: \(.required_pull_request_reviews.required_approving_review_count)\n  vale para admin: \(.enforce_admins.enabled)\n  historia linear: \(.required_linear_history.enabled)"' 2>/dev/null \
  || echo "  nao consegui ler a protecao (a main ja foi enviada?)"

echo
echo "O que so voce pode fazer (nenhum segredo passa por este script):"
echo "  a) Token da revisao por IA:   gh secret set CLAUDE_CODE_OAUTH_TOKEN"
echo "  b) Se publicar:               infra/README.md (Cloudflare ou Vercel)"
echo "  c) Licenca: troque o texto do arquivo LICENSE antes de tornar o repositorio publico."

if [ "$failures" -gt 0 ]; then
  echo
  echo "$failures passo(s) falharam. Causa comum: a main ainda nao foi enviada ao GitHub." >&2
  exit 2
fi
