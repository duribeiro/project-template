#!/usr/bin/env bash
# Preenche o projeto novo criado a partir do modelo.
# Uso: bash scripts/init-project.sh PROJECT-NAME GITHUB-USER "Descricao em uma frase"
set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "Uso: bash scripts/init-project.sh PROJECT-NAME GITHUB-USER \"Descricao em uma frase\"" >&2
  exit 1
fi

project_name="$1"
github_user="$2"
description="$3"

if ! [[ "$project_name" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "O nome deve ter so letras minusculas, numeros e hifen (ex.: my-project)." >&2
  exit 1
fi

cd "$(dirname "$0")/.."

if ! grep -q "NOME-DO-PROJETO" AGENTS.md; then
  echo "O projeto ja foi iniciado (AGENTS.md nao tem mais NOME-DO-PROJETO). Nada a fazer." >&2
  exit 1
fi

today="$(date +%Y-%m-%d)"

sed -i "s/NOME-DO-PROJETO/${project_name}/g" AGENTS.md openspec/config.yaml
sed -i "s/^Descreva em uma frase.*$/${description}/" AGENTS.md
sed -i "s/descreva em uma frase o que o projeto e, para quem, e o dominio./${description}/" openspec/config.yaml
sed -i "s/\"name\": \"project-name\"/\"name\": \"${project_name}\"/" package.json
sed -i "s/@duribeiro/@${github_user}/" .github/CODEOWNERS
sed -i "s/^## \[0.0.1\] - YYYY-MM-DD/## [0.0.1] - ${today}/" CHANGELOG.md

cat > README.md <<EOF
# ${project_name}

[![Release](https://img.shields.io/github/v/release/${github_user}/${project_name})](https://github.com/${github_user}/${project_name}/releases)
[![CI](https://github.com/${github_user}/${project_name}/actions/workflows/ci.yml/badge.svg)](https://github.com/${github_user}/${project_name}/actions/workflows/ci.yml)
[![License](https://img.shields.io/github/license/${github_user}/${project_name})](LICENSE)
[![Dependabot](https://img.shields.io/badge/dependabot-enabled-025e8c?logo=dependabot)](.github/dependabot.yml)
[![Conventional Commits](https://img.shields.io/badge/commits-conventional-fe5196)](https://www.conventionalcommits.org/pt-br/v1.0.0/)

${description}

## Como trabalhar neste projeto

- Regras do agente e do projeto: [AGENTS.md](AGENTS.md).
- Como uma mudança chega na \`main\`: [CONTRIBUTING.md](CONTRIBUTING.md).
- Onde o trabalho parou: [pipeline/STATE.md](pipeline/STATE.md).
- Decisões tomadas: [pipeline/decisions](pipeline/decisions/README.md).
- Histórico de versões: [CHANGELOG.md](CHANGELOG.md).
EOF

echo "Projeto iniciado: ${project_name} (versao 0.0.1, ${today})"
echo "Conferencia de espacos reservados que sobraram:"
grep -n "NOME-DO-PROJETO\|\"project-name\"\|YYYY-MM-DD" AGENTS.md openspec/config.yaml package.json CHANGELOG.md || echo "  nenhum"
echo "Proximo passo: commit e push da main, depois: bash scripts/configure-github.sh"
