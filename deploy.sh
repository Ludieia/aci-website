#!/usr/bin/env bash
set -Eeuo pipefail

APP_NAME="acicorp"
WEB_ROOT="/var/www/acicorp"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_BASE="/var/www/${APP_NAME}_backup_$(date +%F_%H-%M-%S)"
DOMAIN="acicorpinc.com"

log(){ printf '\n[ACI DEPLOY] %s\n' "$1"; }
fail(){ printf '\n[ACI DEPLOY ERROR] %s\n' "$1" >&2; exit 1; }

[ "$(id -u)" -eq 0 ] || fail "Run this script as root or with sudo."
command -v git >/dev/null 2>&1 || fail "git is not installed."
command -v nginx >/dev/null 2>&1 || fail "nginx is not installed."
command -v curl >/dev/null 2>&1 || fail "curl is not installed."

log "Starting deployment for ${DOMAIN}"

log "Creating backup of ${WEB_ROOT}"
if [ -d "$WEB_ROOT" ]; then
  cp -a "$WEB_ROOT" "$BACKUP_BASE"
  echo "Backup created: $BACKUP_BASE"
else
  mkdir -p "$WEB_ROOT"
  echo "Web root did not exist. Created: $WEB_ROOT"
fi

log "Pulling latest version from Git"
cd "$REPO_DIR"
git pull --ff-only || fail "git pull failed. Fix Git conflicts or repository state, then retry."

log "Validating repository structure"
[ -f "$REPO_DIR/index.html" ] || fail "Missing index.html"
[ -f "$REPO_DIR/assets/styles.css" ] || fail "Missing assets/styles.css"
[ -f "$REPO_DIR/assets/site.js" ] || fail "Missing assets/site.js"
[ -d "$REPO_DIR/assets/images" ] || fail "Missing assets/images/"
[ -d "$REPO_DIR/pages" ] || fail "Missing pages/"

log "Copying files to ${WEB_ROOT}"
mkdir -p "$WEB_ROOT"
rsync -a --delete \
  --exclude='.git' \
  --exclude='deploy.sh' \
  --exclude='README.md' \
  "$REPO_DIR/" "$WEB_ROOT/"

log "Setting permissions"
chown -R www-data:www-data "$WEB_ROOT"
chmod -R 755 "$WEB_ROOT"

log "Testing Nginx configuration"
nginx -t || {
  echo "Nginx test failed. Restoring backup..."
  rsync -a --delete "$BACKUP_BASE/" "$WEB_ROOT/"
  chown -R www-data:www-data "$WEB_ROOT"
  chmod -R 755 "$WEB_ROOT"
  fail "Deployment aborted and backup restored."
}

log "Reloading Nginx"
systemctl reload nginx || systemctl restart nginx || fail "Could not reload or restart nginx."

log "Running local HTTP check"
HTTP_CODE="$(curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1/" -H "Host: ${DOMAIN}" || true)"
echo "Local HTTP status: ${HTTP_CODE}"

log "Running local HTTPS check"
HTTPS_CODE="$(curl -k -s -o /dev/null -w '%{http_code}' "https://127.0.0.1/" -H "Host: ${DOMAIN}" || true)"
echo "Local HTTPS status: ${HTTPS_CODE}"

log "Running public domain check"
PUBLIC_CODE="$(curl -L -s -o /dev/null -w '%{http_code}' "https://${DOMAIN}" || true)"
echo "Public HTTPS status: ${PUBLIC_CODE}"

log "Deployment status"
echo "Web root: $WEB_ROOT"
echo "Backup: $BACKUP_BASE"
echo "Repository: $REPO_DIR"
ls -la "$WEB_ROOT" | sed -n '1,30p'

if [ "$HTTP_CODE" = "200" ] || [ "$HTTPS_CODE" = "200" ]; then
  echo "SUCCESS: Deployment completed. If Cloudflare still shows old content, purge Cloudflare cache."
else
  echo "WARNING: Files deployed and Nginx reloaded, but local curl did not return 200. Check Nginx server block/root."
fi
