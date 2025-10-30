#!/usr/bin/env bash
set -euo pipefail

echo "Setting up WordPress"
DEVDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd /var/www/html

# Check if WordPress is already set up
if [ -f wp-config.php ] && wp core is-installed 2>/dev/null; then
    echo "WordPress is already installed, skipping setup"
    exit 0
fi

# optional reset
if [ "${WP_RESET:-false}" = true ]; then
    wp db reset --yes
    rm -f wp-config.php
fi

# configure wp-config and salts
if [ ! -f wp-config.php ]; then
    wp config create --dbhost="${WORDPRESS_DB_HOST:-db}" --dbname="${WORDPRESS_DB_NAME:-wordpress}" --dbuser="${WORDPRESS_DB_USER:-wp_user}" --dbpass="${WORDPRESS_DB_PASSWORD:-wp_pass}" --skip-check
    wp config shuffle-salts
fi

# install core if not installed
wp core is-installed || wp core install --url="${WP_HOME:-http://localhost:8080}" --title="${SITE_TITLE:-Dev Site}" --admin_user="${ADMIN_USER:-admin}" --admin_email="${ADMIN_EMAIL:-admin@localhost.com}" --admin_password="${ADMIN_PASSWORD:-password}" --skip-email

# install/activate plugins if specified
if [ -n "${WP_PLUGINS:-}" ]; then
    wp plugin install ${WP_PLUGINS} --activate || true
fi

# copy and activate any local plugins
if [ -d "${DEVDIR}/plugins" ]; then
    cp -r ${DEVDIR}/plugins/* wp-content/plugins/ || true
    for p in ${DEVDIR}/plugins/*; do
        [ -e "$p" ] && wp plugin activate "$(basename "$p")" || true
    done
fi

# import any SQL dumps
if [ -d "${DEVDIR}/data" ]; then
    for f in ${DEVDIR}/data/*.sql; do
        [ -f "$f" ] && wp db import "$f"
    done
fi

echo "WordPress setup complete"