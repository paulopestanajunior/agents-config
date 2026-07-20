#!/bin/sh
# Copia os perfis portáveis (AGENTS.md, profiles/, copilot-instructions.md)
# para um projeto, para que Codex e Copilot reconheçam os mesmos 5 perfis
# de especialista usados no Claude Code.
#
# Uso: ./deploy-to-project.sh /caminho/do/projeto
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="$1"

if [ -z "$TARGET" ]; then
  echo "Uso: ./deploy-to-project.sh /caminho/do/projeto"
  exit 1
fi

if [ ! -d "$TARGET" ]; then
  echo "Pasta não encontrada: $TARGET"
  exit 1
fi

"$REPO_DIR/build-portable.sh"

mkdir -p "$TARGET/profiles"
cp -R "$REPO_DIR/portable/profiles/." "$TARGET/profiles/"
echo "Copiado: profiles/ -> $TARGET/profiles/"

if [ -f "$TARGET/AGENTS.md" ]; then
  echo "Aviso: $TARGET/AGENTS.md já existe. Não sobrescrito."
  echo "Compare manualmente com $REPO_DIR/portable/AGENTS.md.template"
else
  cp "$REPO_DIR/portable/AGENTS.md.template" "$TARGET/AGENTS.md"
  echo "Criado: $TARGET/AGENTS.md (edite a seção 'Escopo do Repositório')"
fi

mkdir -p "$TARGET/.github"
if [ -f "$TARGET/.github/copilot-instructions.md" ]; then
  echo "Aviso: $TARGET/.github/copilot-instructions.md já existe. Não sobrescrito."
  echo "Compare manualmente com $REPO_DIR/portable/copilot-instructions.md.template"
else
  cp "$REPO_DIR/portable/copilot-instructions.md.template" "$TARGET/.github/copilot-instructions.md"
  echo "Criado: $TARGET/.github/copilot-instructions.md"
fi

echo ""
echo "Pronto. Revise e commite os arquivos gerados dentro de $TARGET."
