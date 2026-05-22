#!/usr/bin/env bash
set -e

ROOT_DIR="."
BUILD_DIR="docs"

echo "Preparing ACICORP static site in docs/"

mkdir -p "$BUILD_DIR"
mkdir -p "$BUILD_DIR/pages"
mkdir -p "$BUILD_DIR/assets"

cp index.html "$BUILD_DIR/index.html"
cp about.html "$BUILD_DIR/about.html"
cp contact.html "$BUILD_DIR/contact.html"
cp donate.html "$BUILD_DIR/donate.html"
cp programs.html "$BUILD_DIR/programs.html"

cp -R pages/. "$BUILD_DIR/pages/"
cp -R assets/. "$BUILD_DIR/assets/"

if [ -f robots.txt ]; then cp robots.txt "$BUILD_DIR/robots.txt"; fi
if [ -f sitemap.xml ]; then cp sitemap.xml "$BUILD_DIR/sitemap.xml"; fi
if [ -f README.md ]; then cp README.md "$BUILD_DIR/README.md"; fi

touch "$BUILD_DIR/.nojekyll"

echo "ACICORP build ready in docs/"
