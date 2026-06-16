#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────────
# release.sh  —  Incrementa la versione di transfers e crea un tag git.
#
# Uso:
#   ./scripts/release.sh           # incrementa PATCH  (1.0.3 → 1.0.4)
#   ./scripts/release.sh patch     # stesso effetto
#   ./scripts/release.sh minor     # incrementa MINOR  (1.0.3 → 1.1.0)
#   ./scripts/release.sh major     # incrementa MAJOR  (1.0.3 → 2.0.0)
# ──────────────────────────────────────────────────────────────────────────────
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PUBSPEC="$SCRIPT_DIR/../pubspec.yaml"
BUMP="${1:-patch}"

# ── Leggi versione attuale ─────────────────────────────────────────────────────
CURRENT=$(grep '^version:' "$PUBSPEC" | sed 's/version:[[:space:]]*//')
if [[ -z "$CURRENT" ]]; then
  echo "❌ Versione non trovata in pubspec.yaml" >&2
  exit 1
fi
echo "Versione attuale: $CURRENT"

BASE="${CURRENT%%+*}"
MAJOR=$(echo "$BASE" | cut -d'.' -f1)
MINOR=$(echo "$BASE" | cut -d'.' -f2)
PATCH=$(echo "$BASE" | cut -d'.' -f3)

# ── Calcola nuova versione ─────────────────────────────────────────────────────
case "$BUMP" in
  major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
  minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
  patch) PATCH=$((PATCH + 1)) ;;
  *)
    echo "❌ Parametro non valido: '$BUMP'. Usa: major | minor | patch" >&2
    exit 1
    ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
echo "Nuova versione:   $NEW_VERSION"
echo ""

# ── Verifica working tree pulito ───────────────────────────────────────────────
cd "$SCRIPT_DIR/.."
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "❌ Working tree non pulito. Esegui commit o stash prima del rilascio." >&2
  exit 1
fi

# ── Aggiorna pubspec.yaml ──────────────────────────────────────────────────────
sed -i "s/^version:.*/version: ${NEW_VERSION}/" "$PUBSPEC"
echo "✓ pubspec.yaml aggiornato → $NEW_VERSION"

# ── Rigenera lib/src/package_version.dart ─────────────────────────────────────
PKG_VERSION_FILE="$SCRIPT_DIR/../lib/src/package_version.dart"
cat > "$PKG_VERSION_FILE" << EOF
// AUTO-GENERATED — do not edit manually. Run scripts/release.sh to update.
const String kTransfersVersion = '${NEW_VERSION}';
EOF
echo "✓ package_version.dart aggiornato → $NEW_VERSION"

# ── Commit + tag ───────────────────────────────────────────────────────────────
git add "$PUBSPEC" "$PKG_VERSION_FILE"
git commit -m "chore: release v${NEW_VERSION}"
git tag "v${NEW_VERSION}"
echo "✓ Commit creato: chore: release v${NEW_VERSION}"
echo "✓ Tag creato:    v${NEW_VERSION}"

if [[ "${SKIP_RELEASE_HOOK:-}" != "1" ]]; then
  echo ""
  echo "Per pubblicare esegui:"
  echo "  git push && git push --tags"
fi
