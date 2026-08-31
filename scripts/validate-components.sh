#!/bin/sh
# Validate harness components: frontmatter, delegation edges, cycles, and
# unqualified boundary labels. No external dependencies.
set -eu

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
cd "$REPO_DIR"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

ERRORS=0
WARNINGS=0

err() {
  ERRORS=$((ERRORS + 1))
  printf 'ERROR: %s\n' "$1" >&2
}

warn() {
  WARNINGS=$((WARNINGS + 1))
  printf 'WARN:  %s\n' "$1" >&2
}

# ---------------------------------------------------------------------------
# Component inventory. A component is addressable by its title-cased name, so
# "ML Lifecycle Engineer" in a boundary bullet resolves to ml-lifecycle-engineer.
# ---------------------------------------------------------------------------

: > "$WORK/components"

for f in skills/*/SKILL.md; do
  [ -e "$f" ] || continue
  dir_name="$(basename "$(dirname "$f")")"
  printf '%s\n' "$dir_name" >> "$WORK/components"
done

for f in roles/*.md workflows/*.md profiles/*.md rules/*.md; do
  [ -e "$f" ] || continue
  base="$(basename "$f" .md)"
  printf '%s\n' "$base" >> "$WORK/components"
done

sort -u "$WORK/components" -o "$WORK/components"

# ---------------------------------------------------------------------------
# 1. Frontmatter: every SKILL.md declares name and description, and name
#    matches its directory.
# ---------------------------------------------------------------------------

for f in skills/*/SKILL.md; do
  [ -e "$f" ] || continue
  dir_name="$(basename "$(dirname "$f")")"

  if [ "$(head -n 1 "$f")" != "---" ]; then
    err "$f: missing YAML frontmatter"
    continue
  fi

  declared="$(sed -n '2,/^---$/p' "$f" | sed -n 's/^name:[[:space:]]*//p' | head -n 1)"
  if [ -z "$declared" ]; then
    err "$f: frontmatter has no 'name'"
  elif [ "$declared" != "$dir_name" ]; then
    err "$f: frontmatter name '$declared' does not match directory '$dir_name'"
  fi

  if ! sed -n '2,/^---$/p' "$f" | grep -q '^description:'; then
    err "$f: frontmatter has no 'description'"
  fi
done

# ---------------------------------------------------------------------------
# 2. Delegation edges resolve to an existing component.
#    Edge syntax: "-> Some Component Name." at the end of a bullet. Bullets wrap
#    across lines, so unwrap continuations before extracting.
# ---------------------------------------------------------------------------

: > "$WORK/edges"

unwrap_bullets() {
  awk '
    /^[[:space:]]*[-*][[:space:]]/ {
      if (buf != "") print buf
      buf = $0
      next
    }
    /^[[:space:]]+[^[:space:]]/ {
      if (buf != "") {
        line = $0
        sub(/^[[:space:]]+/, " ", line)
        buf = buf line
        next
      }
    }
    {
      if (buf != "") { print buf; buf = "" }
      print
    }
    END { if (buf != "") print buf }
  ' "$1"
}

for f in skills/*/SKILL.md roles/*.md; do
  [ -e "$f" ] || continue

  case "$f" in
    skills/*) origin="$(basename "$(dirname "$f")")" ;;
    *) origin="$(basename "$f" .md)" ;;
  esac

  # "-> Target." possibly with " or " joining two targets.
  unwrap_bullets "$f" \
    | grep -o -- '-> [A-Z][^.;]*' 2>/dev/null \
    | sed 's/^-> //' \
    | sed 's/ or /\n/g' \
    > "$WORK/targets" || true

  while read -r target; do
    [ -n "$target" ] || continue

    slug="$(printf '%s' "$target" \
      | sed 's/[[:space:]]*$//' \
      | tr 'A-Z' 'a-z' \
      | sed 's|/|-|g; s/[[:space:]][[:space:]]*/-/g')"

    # Known aliases between prose names and component slugs.
    case "$slug" in
      ai-engineer) slug="ai-ml-engineer" ;;
      tracking-integrations-qa) slug="qa-tracking-integrations" ;;
    esac

    if grep -qx "$slug" "$WORK/components"; then
      printf '%s -> %s\n' "$origin" "$slug" >> "$WORK/edges"
    else
      printf 'UNRESOLVED %s %s %s\n' "$f" "$slug" "$target" >> "$WORK/unresolved"
    fi
  done < "$WORK/targets"
done

if [ -f "$WORK/unresolved" ]; then
  sort -u "$WORK/unresolved" | while IFS=' ' read -r _ file slug rest; do
    printf 'ERROR: %s: delegation target "%s" (%s) does not resolve to a component\n' \
      "$file" "$rest" "$slug" >&2
  done
  ERRORS=$((ERRORS + $(sort -u "$WORK/unresolved" | wc -l | tr -d ' ')))
fi

# ---------------------------------------------------------------------------
# 3. Cycle detection over the resolved edge set.
#    An edge is a transfer of decision ownership, so a 2-cycle between two
#    components on the same subject is a defect.
# ---------------------------------------------------------------------------

if [ -f "$WORK/edges" ]; then
  sort -u "$WORK/edges" -o "$WORK/edges"

  while read -r a _ b; do
    if grep -qx "$b -> $a" "$WORK/edges"; then
      # Print each pair once.
      if [ "$a" \< "$b" ]; then
        warn "mutual delegation between '$a' and '$b': verify both bullets name a distinct sub-object"
      fi
    fi
  done < "$WORK/edges"
fi

# ---------------------------------------------------------------------------
# 4. Boundary bullets must name a sub-object, not a bare domain label.
# ---------------------------------------------------------------------------

# A bare label is one of these words appearing in a delegation bullet with no
# qualifier in front of it. "production drift" is fine; "drift -> X" is not.
for f in skills/*/SKILL.md; do
  [ -e "$f" ] || continue
  unwrap_bullets "$f" | grep -- '->' | while read -r bullet; do
    lower="$(printf '%s' "$bullet" | tr 'A-Z' 'a-z')"
    case "$lower" in
      *[!a-z-]drift*)
        case "$lower" in
          *production\ drift*|*data\ drift*|*concept\ drift*|*schema\ drift*|*infra\ drift*|*infrastructure\ drift*) ;;
          *) warn "$f: bare label 'drift' in a delegation bullet; qualify it (production/data/concept/schema)" ;;
        esac
        ;;
    esac
    case "$bullet" in
      *[!a-zA-Z-]RAG*)
        case "$bullet" in
          *RAG\ corpus*|*RAG\ pipeline*|*inside\ agentic*|*Agent/RAG/model*) ;;
          *) warn "$f: bare label 'RAG' in a delegation bullet; name the sub-object (corpus vs per-turn retrieval)" ;;
        esac
        ;;
    esac
    case "$bullet" in
      *feature\ store*)
        case "$bullet" in
          *as\ a\ served\ data\ product*|*as\ a\ data\ product*) ;;
          *) warn "$f: bare label 'feature store' in a delegation bullet; name the sub-object (definition/table/serving)" ;;
        esac
        ;;
    esac
  done
done

# ---------------------------------------------------------------------------

printf '\n%s components, %s edges checked. %s error(s), %s warning(s).\n' \
  "$(wc -l < "$WORK/components" | tr -d ' ')" \
  "$([ -f "$WORK/edges" ] && wc -l < "$WORK/edges" | tr -d ' ' || echo 0)" \
  "$ERRORS" "$WARNINGS"

[ "$ERRORS" -eq 0 ] || exit 1
