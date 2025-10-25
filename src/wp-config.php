<?php
$dbHost = getenv('WORDPRESS_DB_HOST') ?: 'db';
$dbName = getenv('WORDPRESS_DB_NAME') ?: 'wordpress';
$dbUser = getenv('WORDPRESS_DB_USER') ?: 'wp_user';
$dbPass = getenv('WORDPRESS_DB_PASSWORD') ?: 'wp_pass';
$table_prefix = getenv('TABLE_PREFIX') ?: 'wp_';
$home = getenv('WP_HOME') ?: 'http://localhost:8080';
$siteUrl = getenv('WP_SITEURL') ?: $home;

define('DB_NAME', $dbName);
define('DB_USER', $dbUser);
define('DB_PASSWORD', $dbPass);
define('DB_HOST', $dbHost);
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

define('WP_DEBUG', (bool) (getenv('WP_DEBUG') ?: '1'));
define('WP_HOME', $home);
define('WP_SITEURL', $siteUrl);
define('FS_METHOD', 'direct');
define('WP_ENVIRONMENT_TYPE', getenv('WP_ENVIRONMENT_TYPE') ?: 'development');
define('DISALLOW_FILE_EDIT', true);

foreach (['AUTH_KEY','SECURE_AUTH_KEY','LOGGED_IN_KEY','NONCE_KEY','AUTH_SALT','SECURE_AUTH_SALT','LOGGED_IN_SALT','NONCE_SALT'] as $k)
    defined($k) || define($k, getenv($k) ?: 'change-me-'.$k);

if (!defined('ABSPATH')) define('ABSPATH', __DIR__ . '/');
require_once ABSPATH.'wp-settings.php';

