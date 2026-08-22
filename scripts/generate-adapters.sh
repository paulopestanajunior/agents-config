#!/bin/sh
set -eu

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
GENERATED_AT="Generated from the canonical agents-config directories. Do not edit by hand."
CATALOG_PT="$REPO_DIR/docs/catalog.pt.tsv"

list_skills() {
  find "$REPO_DIR/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -type f 2>/dev/null | sort |
  while IFS= read -r file; do
    name="$(basename "$(dirname "$file")")"
    title="$(awk '/^# / { sub(/^# /, ""); print; exit }' "$file")"
    [ -n "$title" ] || title="$name"
    rel="${file#"$REPO_DIR"/}"
    printf -- '- `%s` - %s (`%s`)\n' "$name" "$title" "$rel"
  done
}

list_markdown_files() {
  dir="$1"
  find "$REPO_DIR/$dir" -mindepth 1 -maxdepth 1 -name '*.md' -type f 2>/dev/null | sort |
  while IFS= read -r file; do
    name="$(basename "$file" .md)"
    title="$(awk '/^# / { sub(/^# /, ""); print; exit }' "$file")"
    [ -n "$title" ] || title="$name"
    rel="${file#"$REPO_DIR"/}"
    printf -- '- `%s` - %s (`%s`)\n' "$name" "$title" "$rel"
  done
}

table_cell() {
  sed 's/|/\\|/g; s/[[:space:]][[:space:]]*/ /g; s/^ //; s/ $//'
}

skill_description() {
  file="$1"
  awk '
    /^description:[[:space:]]*>-/ { indesc = 1; next }
    indesc && /^  / {
      line = $0
      sub(/^  /, "", line)
      desc = desc " " line
      next
    }
    indesc && !/^  / { indesc = 0 }
    END {
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", desc)
      print desc
    }
  ' "$file"
}

first_paragraph() {
  file="$1"
  awk '
    /^---$/ && NR == 1 { infm = 1; next }
    infm && /^---$/ { infm = 0; next }
    infm { next }
    /^#/ { next }
    /^[[:space:]]*$/ {
      if (para != "") {
        print para
        found = 1
        exit
      }
      next
    }
    {
      if (para != "") {
        para = para " " $0
      } else {
        para = $0
      }
    }
    END {
      if (!found && para != "") {
        print para
      }
    }
  ' "$file"
}

avoid_text() {
  type="$1"
  case "$type" in
    Skill) printf 'Use outro especialista quando a tarefa estiver fora desta expertise.' ;;
    Role) printf 'Use skill/workflow/profile quando precisar apenas de expertise, sequência ou profundidade.' ;;
    Workflow) printf 'Evite quando a tarefa não seguir esta sequência de execução.' ;;
    Profile) printf 'Evite quando a profundidade, autonomia ou postura de risco pedida for diferente.' ;;
    Rule) printf 'Não ignore silenciosamente; documente exceções específicas do projeto em `.agents/overrides/`.' ;;
  esac
}

default_purpose() {
  type="$1"
  name="$2"
  case "$type" in
    Skill) printf 'Skill `%s`' "$name" ;;
    Role) printf 'Role `%s`' "$name" ;;
    Workflow) printf 'Workflow `%s`' "$name" ;;
    Profile) printf 'Profile `%s`' "$name" ;;
    Rule) printf 'Rule `%s`' "$name" ;;
  esac
}

default_when() {
  type="$1"
  name="$2"
  case "$type" in
    Skill) printf 'Use quando a tarefa exigir a especialidade `%s`. Consulte o arquivo canônico para critérios detalhados.' "$name" ;;
    Role) printf 'Use quando a tarefa exigir a postura operacional `%s`. Consulte o arquivo canônico para critérios detalhados.' "$name" ;;
    Workflow) printf 'Use quando a tarefa seguir a sequência de execução `%s`. Consulte o arquivo canônico para critérios detalhados.' "$name" ;;
    Profile) printf 'Use quando a tarefa exigir a profundidade, autonomia ou postura de risco `%s`. Consulte o arquivo canônico para critérios detalhados.' "$name" ;;
    Rule) printf 'Use como restrição durável quando `%s` for relevante para a tarefa ou projeto. Consulte o arquivo canônico para critérios detalhados.' "$name" ;;
  esac
}

annotation_row() {
  type="$1"
  name="$2"
  purpose="$(default_purpose "$type" "$name")"
  when="$(default_when "$type" "$name")"
  avoid="$(avoid_text "$type")"
  printf '%s\t%s\t%s\t%s\t%s\n' "$type" "$name" "$purpose" "$when" "$avoid"
}

write_expected_catalog_annotations() {
  out="$1"
  {
    printf 'Type\tName\tPurpose\tWhen\tAvoid\n'
    find "$REPO_DIR/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -type f 2>/dev/null | sort |
    while IFS= read -r file; do
      annotation_row Skill "$(basename "$(dirname "$file")")"
    done
    for dir in roles workflows profiles rules; do
      find "$REPO_DIR/$dir" -mindepth 1 -maxdepth 1 -name '*.md' -type f 2>/dev/null | sort |
      while IFS= read -r file; do
        name="$(basename "$file" .md)"
        case "$dir" in
          roles) type=Role ;;
          workflows) type=Workflow ;;
          profiles) type=Profile ;;
          rules) type=Rule ;;
        esac
        annotation_row "$type" "$name"
      done
    done
  } > "$out"
}

ensure_catalog_annotations() {
  mkdir -p "$(dirname "$CATALOG_PT")"
  expected="$CATALOG_PT.expected"
  next="$CATALOG_PT.next"
  write_expected_catalog_annotations "$expected"
  if [ -f "$CATALOG_PT" ]; then
    awk -F '\t' '
      NR == FNR {
        if (FNR > 1) {
          existing[$1 "\t" $2] = $0
        }
        next
      }
      FNR == 1 {
        print
        next
      }
      {
        key = $1 "\t" $2
        if (key in existing) {
          print existing[key]
        } else {
          print
        }
      }
    ' "$CATALOG_PT" "$expected" > "$next"
    mv "$next" "$CATALOG_PT"
    rm "$expected"
  else
    mv "$expected" "$CATALOG_PT"
  fi
}

annotation_field() {
  type="$1"
  name="$2"
  field="$3"
  [ -f "$CATALOG_PT" ] || return 0
  awk -F '\t' -v type="$type" -v name="$name" -v field="$field" '
    NR > 1 && $1 == type && $2 == name {
      print $field
      exit
    }
  ' "$CATALOG_PT"
}

catalog_row() {
  type="$1"
  name="$2"
  purpose="$3"
  when="$4"
  path="$5"
  avoid="${6:-$(avoid_text "$type")}"
  purpose="$(printf '%s' "$purpose" | table_cell)"
  when="$(printf '%s' "$when" | table_cell)"
  avoid="$(printf '%s' "$avoid" | table_cell)"
  printf '| %s | `%s` | %s | %s | %s | `%s` |\n' "$type" "$name" "$purpose" "$when" "$avoid" "$path"
}

write_catalog() {
  out="$REPO_DIR/docs/catalog.generated.md"
  mkdir -p "$(dirname "$out")"
  {
    printf '# Catálogo Gerado De Componentes\n\n'
    printf 'Gerado a partir dos diretórios canônicos do agents-config. Não edite manualmente.\n\n'
    printf 'Fonte da verdade: `skills/*/SKILL.md`, `roles/*.md`, `workflows/*.md`, `profiles/*.md` e `rules/*.md`.\n\n'
    printf 'Observação: nomes e caminhos vêm dos arquivos canônicos usados pelos agents. Os textos em português vêm de `docs/catalog.pt.tsv` quando existirem; novos componentes sem anotação aparecem com fallback em português.\n\n'
    printf '| Tipo | Nome | Finalidade | Quando Usar | Quando Evitar | Caminho |\n'
    printf '|---|---|---|---|---|---|\n'

    find "$REPO_DIR/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -type f 2>/dev/null | sort |
    while IFS= read -r file; do
      name="$(basename "$(dirname "$file")")"
      title="$(awk '/^# / { sub(/^# /, ""); print; exit }' "$file")"
      [ -n "$title" ] || title="$name"
      desc="$(skill_description "$file")"
      [ -n "$desc" ] || desc="$(first_paragraph "$file")"
      pt_purpose="$(annotation_field Skill "$name" 3)"
      pt_when="$(annotation_field Skill "$name" 4)"
      pt_avoid="$(annotation_field Skill "$name" 5)"
      [ -n "$pt_purpose" ] && title="$pt_purpose"
      if [ -n "$pt_when" ]; then
        desc="$pt_when"
      else
        desc="Use quando a tarefa exigir a especialidade \`$name\`. Consulte o arquivo canônico para critérios detalhados."
      fi
      rel="${file#"$REPO_DIR"/}"
      catalog_row Skill "$name" "$title" "$desc" "$rel" "$pt_avoid"
    done

    for dir in roles workflows profiles rules; do
      find "$REPO_DIR/$dir" -mindepth 1 -maxdepth 1 -name '*.md' -type f 2>/dev/null | sort |
      while IFS= read -r file; do
        name="$(basename "$file" .md)"
        title="$(awk '/^# / { sub(/^# /, ""); print; exit }' "$file")"
        [ -n "$title" ] || title="$name"
        summary="$(first_paragraph "$file")"
        [ -n "$summary" ] || summary="$title"
        rel="${file#"$REPO_DIR"/}"
        case "$dir" in
          roles) type=Role ;;
          workflows) type=Workflow ;;
          profiles) type=Profile ;;
          rules) type=Rule ;;
        esac
        pt_purpose="$(annotation_field "$type" "$name" 3)"
        pt_when="$(annotation_field "$type" "$name" 4)"
        pt_avoid="$(annotation_field "$type" "$name" 5)"
        [ -n "$pt_purpose" ] && title="$pt_purpose"
        if [ -n "$pt_when" ]; then
          summary="$pt_when"
        else
          summary="Use quando precisar do componente \`$name\`. Consulte o arquivo canônico para critérios detalhados."
        fi
        catalog_row "$type" "$name" "$title" "$summary" "$rel" "$pt_avoid"
      done
    done
  } > "$out"
}

write_component_index() {
  out="$1"
  title="$2"
  mkdir -p "$(dirname "$out")"
  {
    printf '# %s\n\n' "$title"
    printf '%s\n\n' "$GENERATED_AT"
    printf '## Skills\n\n'
    list_skills
    printf '\n## Roles\n\n'
    list_markdown_files roles
    printf '\n## Workflows\n\n'
    list_markdown_files workflows
    printf '\n## Profiles\n\n'
    list_markdown_files profiles
    printf '\n## Rules\n\n'
    list_markdown_files rules
  } > "$out"
}

write_agent_bundle() {
  out="$1"
  title="$2"
  tmp="$out.tmp"
  mkdir -p "$(dirname "$out")"
  {
    printf '# %s\n\n' "$title"
    printf '%s\n\n' "$GENERATED_AT"
    printf '## Canonical Global Harness\n\n'
    awk 'NR > 1 { print }' "$REPO_DIR/AGENTS.md"
    printf '\n## Component Index\n\n'
  } > "$tmp"
  write_component_index "$out" "$title Component Index"
  cat "$tmp" "$out" > "$out.next"
  mv "$out.next" "$out"
  rm "$tmp"
}

write_component_index "$REPO_DIR/adapters/claude/COMPONENTS.md" "Claude Component Index"
write_agent_bundle "$REPO_DIR/adapters/codex/AGENTS.md" "Codex Global Instructions"
write_agent_bundle "$REPO_DIR/adapters/kimi/AGENTS.md" "Kimi Global Instructions"
write_agent_bundle "$REPO_DIR/adapters/zcode/AGENTS.md" "ZCode Global Instructions"
write_agent_bundle "$REPO_DIR/adapters/copilot/instructions/agents-config.generated.md" "Copilot Global Instructions"
ensure_catalog_annotations
write_catalog

mkdir -p "$REPO_DIR/adapters/copilot/profiles"
find "$REPO_DIR/adapters/copilot/profiles" -mindepth 1 -maxdepth 1 -name '*.md' -type f -delete

for skill in "$REPO_DIR"/skills/*/SKILL.md; do
  [ -f "$skill" ] || continue
  name="$(basename "$(dirname "$skill")")"
  out="$REPO_DIR/adapters/copilot/profiles/$name.md"
  awk '
    NR == 1 && $0 == "---" { infm = 1; next }
    infm && $0 == "---" { infm = 0; next }
    !infm { print }
  ' "$skill" | sed '/./,$!d' > "$out"
done

echo "Generated adapters and docs from canonical components."
