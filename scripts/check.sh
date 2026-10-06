#!/usr/bin/env bash
# Checks every skill in skills/ and greps the repository for text that must
# never be published. Exit 1 on any failure.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
n_ok=0
n_failed=0
ok()   { echo "  [PASS] $1"; n_ok=$((n_ok + 1)); }
fail() { echo "  [FAIL] $1"; n_failed=$((n_failed + 1)); }

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

echo "=== repository files ==="
# The plugin manifests are checked in CI by `claude plugin validate --strict`.
junk="$(cd "$ROOT" && git ls-files -co --exclude-standard | grep -E '(^|/)(\.DS_Store|Thumbs\.db|desktop\.ini|__MACOSX)(/|$)' || true)"
if [ -z "$junk" ]; then ok "no system files"; else fail "system files found:"; echo "$junk"; fi

echo "=== leak grep ==="
# Generic patterns only: absolute home directories and issue-number references.
# Further private terms come from LEAK_PATTERN_EXTRA (an extended regular
# expression; CI passes it from a repository secret), so this public file never
# spells them. This file is excluded from the grep: it has to spell its own patterns.
pattern='/Users/|/home/|(^|[^&a-zA-Z0-9])#[0-9]{2,}\b'
if [ -n "${LEAK_PATTERN_EXTRA:-}" ]; then
  pattern="$pattern|$LEAK_PATTERN_EXTRA"
  ok "extra leak patterns loaded from LEAK_PATTERN_EXTRA"
else
  echo "  [NOTE] LEAK_PATTERN_EXTRA is not set: generic patterns only"
fi
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
echo "$n_ok passed, $n_failed failed"
[ "$n_failed" -eq 0 ]
