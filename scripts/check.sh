#!/usr/bin/env bash
# Checks every skill in skills/ and greps the repository for text that must
# never be published. Exit 1 on any failure.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PASS=0
FAIL=0
ok()   { echo "  [PASS] $1"; PASS=$((PASS + 1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL + 1)); }

echo "=== skills ==="
found=0
for md in "$ROOT"/skills/*/SKILL.md; do
  [ -f "$md" ] || continue
  found=1
  dir="$(basename "$(dirname "$md")")"
  if [ "$(head -n 1 "$md")" != "---" ]; then
    fail "$dir: SKILL.md does not start with a --- frontmatter line"
    continue
  fi
  front="$(awk 'NR==1{next} /^---$/{exit} {print}' "$md")"
  name="$(printf '%s\n' "$front" | sed -n 's/^name:[[:space:]]*//p' | head -n 1)"
  if [ "$name" = "$dir" ]; then ok "$dir: name matches its folder"; else fail "$dir: name '$name' does not match folder"; fi
  if printf '%s' "$name" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$' && [ ${#name} -le 64 ]; then
    ok "$dir: name is lowercase-hyphen and at most 64 characters"
  else
    fail "$dir: name must be lowercase letters, digits and hyphens, at most 64 characters"
  fi
  # description: a folded block (>- then indented lines) or a single line.
  desc="$(printf '%s\n' "$front" | awk '
    /^description:/ { sub(/^description:[[:space:]]*/, ""); if ($0 !~ /^[>|]/) { print; exit } inblk=1; next }
    inblk && /^[[:space:]]+/ { sub(/^[[:space:]]+/, ""); printf "%s ", $0; next }
    inblk { exit }')"
  desc="$(printf '%s' "$desc" | sed 's/[[:space:]]*$//')"
  if [ -n "$desc" ] && [ ${#desc} -le 1024 ]; then
    ok "$dir: description present (${#desc} characters, limit 1024)"
  else
    fail "$dir: description missing or over 1024 characters (${#desc})"
  fi
  # Every references/*.md the skill names must exist.
  for ref in $(grep -oE 'references/[a-z0-9-]+\.md' "$md" | sort -u); do
    if [ -f "$(dirname "$md")/$ref" ]; then ok "$dir: $ref exists"; else fail "$dir: $ref is named but missing"; fi
  done
done
[ "$found" = 1 ] && ok "at least one skill found" || fail "no skills/*/SKILL.md found"

echo "=== plugin ==="
for f in .claude-plugin/plugin.json .claude-plugin/marketplace.json .mcp.json; do
  if [ ! -f "$ROOT/$f" ]; then fail "$f is missing"; continue; fi
  if node -e 'JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"))' "$ROOT/$f" 2>/dev/null; then
    ok "$f is valid JSON"
  else
    fail "$f is not valid JSON"
  fi
done
pver="$(node -p 'require(process.argv[1]).version' "$ROOT/.claude-plugin/plugin.json" 2>/dev/null)"
for md in "$ROOT"/skills/*/SKILL.md; do
  [ -f "$md" ] || continue
  sdir="$(basename "$(dirname "$md")")"
  sver="$(sed -n 's/^[[:space:]]*version:[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}[[:space:]]*$/\1/p' "$md" | head -n 1)"
  if [ "$sver" = "$pver" ]; then ok "$sdir: version $sver matches plugin.json"; else fail "$sdir: version '$sver' differs from plugin.json '$pver'"; fi
done
junk="$(cd "$ROOT" && git ls-files -co --exclude-standard | grep -E '(^|/)(\.DS_Store|Thumbs\.db|desktop\.ini|__MACOSX)(/|$)' || true)"
if [ -z "$junk" ]; then ok "no system files"; else fail "system files found:"; echo "$junk"; fi

echo "=== leak grep ==="
# Words that would reveal private repositories or tooling. This file is
# excluded: it has to spell them.
pattern='monorepo|\bpulse\b|superpowers|docs/superpowers|/Users/|tedomac|tp322d/lastping($|[^-])|(^|[^&a-zA-Z0-9])#[0-9]{2,}\b'
hits="$(cd "$ROOT" && git ls-files -co --exclude-standard | grep -v '^scripts/check.sh$' | xargs grep -nIiE "$pattern" 2>/dev/null || true)"
if [ -z "$hits" ]; then ok "no private references in tracked files"; else fail "private references found:"; echo "$hits"; fi

if git -C "$ROOT" rev-parse --verify -q HEAD >/dev/null; then
  if git -C "$ROOT" log --format=%B | grep -qiE 'co-authored-by|generated with'; then
    fail "a commit message carries an attribution trailer"
  else
    ok "no attribution trailers in commit messages"
  fi
  if git -C "$ROOT" log --format=%B | grep -qiE "$pattern"; then
    fail "a commit message contains a private reference"
  else
    ok "no private references in commit messages"
  fi
fi

echo ""
echo "$PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
