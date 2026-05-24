#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$ROOT_DIR/docs"

cd "$ROOT_DIR"

echo "Preparing ACICORP static site in docs/"

required_files=(
  "index.html"
  "about.html"
  "contact.html"
  "donate.html"
  "programs.html"
  "pages/about.html"
  "pages/programs.html"
  "pages/donate.html"
  "assets/styles.css"
  "assets/visual-handoff.css"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing required file: $file" >&2
    exit 1
  fi
done

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

cp index.html "$BUILD_DIR/index.html"
cp about.html "$BUILD_DIR/about.html"
cp contact.html "$BUILD_DIR/contact.html"
cp donate.html "$BUILD_DIR/donate.html"
cp programs.html "$BUILD_DIR/programs.html"

cp -R pages "$BUILD_DIR/pages"
cp -R assets "$BUILD_DIR/assets"

[[ -f site.js ]] && cp site.js "$BUILD_DIR/site.js"
[[ -f robots.txt ]] && cp robots.txt "$BUILD_DIR/robots.txt"
[[ -f sitemap.xml ]] && cp sitemap.xml "$BUILD_DIR/sitemap.xml"
[[ -f README.md ]] && cp README.md "$BUILD_DIR/README.md"
[[ -d handoff ]] && cp -R handoff "$BUILD_DIR/handoff"

touch "$BUILD_DIR/.nojekyll"

echo "ACICORP build ready in docs/"
echo "Output: $BUILD_DIR"
