#!/usr/bin/env bash
# Preenche o projeto novo criado a partir do modelo.
# Uso: bash scripts/iniciar-projeto.sh NOME-DO-PROJETO USUARIO-GITHUB "Descricao em uma frase"
set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "Uso: bash scripts/iniciar-projeto.sh NOME-DO-PROJETO USUARIO-GITHUB \"Descricao em uma frase\"" >&2
  exit 1
fi

nome="$1"
usuario="$2"
descricao="$3"

if ! [[ "$nome" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "O nome deve ter so letras minusculas, numeros e hifen (ex.: meu-projeto)." >&2
  exit 1
fi

cd "$(dirname "$0")/.."

if grep -q "NOME-DO-PROJETO" AGENTS.md; then
  :
else
  echo "O projeto ja foi iniciado (AGENTS.md nao tem mais NOME-DO-PROJETO). Nada a fazer." >&2
  exit 1
fi

sed -i "s/NOME-DO-PROJETO/${nome}/g" AGENTS.md openspec/config.yaml
sed -i "s/^Descreva em uma frase.*$/${descricao}/" AGENTS.md
sed -i "s/\"name\": \"project-name\"/\"name\": \"${nome}\"/" package.json
sed -i "s/@duribeiro/@${usuario}/" .github/CODEOWNERS
sed -i "s/descreva em uma frase o que o projeto e, para quem, e o dominio./${descricao}/" openspec/config.yaml

echo "Projeto iniciado: ${nome}"
echo "Conferencia:"
grep -n "NOME-DO-PROJETO\|project-name" AGENTS.md openspec/config.yaml package.json || echo "  nenhum espaco reservado sobrando"
echo "Proximo passo: bash scripts/configurar-github.sh"
