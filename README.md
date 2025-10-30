# WP DevBox

[![License: GPL v2 or later](https://img.shields.io/badge/License-GPL%20v2%20or%20later-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)
[![PHP Version](https://img.shields.io/badge/PHP-8.2-777BB4?logo=php&logoColor=white)](https://php.net)
[![WordPress](https://img.shields.io/badge/WordPress-6.0+-21759B?logo=wordpress&logoColor=white)](https://wordpress.org)
[![Docker](https://img.shields.io/badge/Docker-Enabled-2496ED?logo=docker&logoColor=white)](https://docker.com)
[![Node.js](https://img.shields.io/badge/Node.js-20-339933?logo=node.js&logoColor=white)](https://nodejs.org)

A complete WordPress Docker development environment that works with any IDE or
editor. This setup provides concurrent theme and plugin development with
centralized configuration, automatic WordPress installation, and all the tools
you need for modern WordPress development.

## Features

- **🔄 Concurrent Development**: Develop both themes and plugins simultaneously
  with volume mounting
- **⚙️ Centralized Configuration**: All settings managed through
  `.devcontainer/.env` file
- **🛠️ Makefile Commands**: Simple commands for all common development tasks
- **🐳 Docker-First**: Works with any IDE - VS Code, PhpStorm, Sublime Text,
  Vim, etc.
- **🔧 Pre-configured Tools**: WP-CLI, Composer, Node.js 20 with pnpm, Xdebug 3
- **📧 Email Testing**: Mailhog integration for testing WordPress emails
- **🗄️ Database Management**: MariaDB with automatic WordPress installation
- **🔍 Debugging Ready**: Xdebug configured for both VS Code and other IDEs

## Requirements

- **Docker** and **Docker Compose**
- **VS Code with Dev Containers extension** (optional, for enhanced experience)
- **Make** (optional, for convenient commands)

## Quick Start

### Recommended: Use this template

1. Create your repository from this template on GitHub (Use this template)
2. Clone your new repository:
   ```bash
   git clone https://github.com/<you>/<your-repo>.git
   cd <your-repo>
   ```

#### With VS Code Dev Containers

1. Open in VS Code:
   ```bash
   code .
   ```
2. Reopen in Container when prompted, or use `Ctrl+Shift+P` → "Dev Containers:
   Reopen in Container"
3. WordPress will be available at http://localhost:8080

#### Without Dev Containers (Any IDE)

1. Initialize and start:
   ```bash
   make setup
   make up
   ```
2. Access WordPress at http://localhost:8080
3. Edit files in `src/themes/my-theme/` and `src/plugins/my-plugin/`
4. Shell into the container when needed:
   ```bash
   make shell
   ```

### Alternative: Manual clone (for testing/contrib)

```bash
git clone https://github.com/<template-owner>/<template-repo>.git
cd <template-repo>
```

## Configuration

All development settings are centralized in `.devcontainer/.env`. To get
started:

1. Run `make setup` to create `.devcontainer/.env` from the example file
2. Customize any values in `.devcontainer/.env` as needed

Key configuration options:

- **Database**: `WORDPRESS_DB_*` variables for database connection
- **WordPress**: `WP_*` variables for WordPress core settings
- **Development**: `THEME_SLUG`, `PLUGIN_SLUG` for your theme/plugin names
- **WP-CLI Setup**: `SITE_TITLE`, `ADMIN_*` for initial WordPress installation
- **Ports**: `WP_PORT`, `MAILHOG_PORT` for service ports

The `.env` file is gitignored, so your local customizations won't be committed.

## Development Commands

```bash
# Show all available commands
make help

# First time setup
make setup

# Start development environment
make up

# View logs
make logs

# Access WordPress shell
make shell

# Run WP-CLI commands
make wp cmd="plugin list"

# Stop environment
make down

# Clean everything (removes volumes)
make clean
```

## Debugging

### VS Code + Xdebug

1. Open the project in VS Code and Reopen in Container
2. Ensure the Docker container is running (`make up`)
3. Use the preconfigured launch: Run and Debug → "Listen for Xdebug (Docker)"
4. Set breakpoints in your theme under `wp-content/themes/my-theme` or plugin
   under `wp-content/plugins/my-plugin`

### Other IDEs + Xdebug

1. Start the environment: `make up`
2. Configure your IDE to connect to Xdebug:
   - **Host**: `localhost`
   - **Port**: `9003`
   - **Path mapping**: Local `src/` → Container `/var/www/html/wp-content/`
3. Set breakpoints in your local `src/` files
4. Start debugging session in your IDE

## Email Testing (Mailhog)

- **Mailhog UI**: http://localhost:8025
- **PHP mail()** is routed to Mailhog via mhsendmail; no extra config needed

## Data Management

### Database Imports

Any `.sql` files placed in `.devcontainer/data` will be automatically imported
when your site is built (using `wp db import`). Ensure table name prefixes match
(default is `wp_`).

### Plugin Auto-Installation

Anything placed in the `.devcontainer/data/plugins` folder (single files or
folders) will be copied into the WordPress plugins folder and activated as a
plugin. This enables things like defining custom post types relevant to your
imported data set.

## Versions

- **PHP 8.2** with Xdebug 3 (port 9003)
- **Node.js 20** with pnpm via corepack
- **MariaDB 10.11**
- **WordPress** (latest)

## Troubleshooting

### Common Issues

**Container won't start:**

```bash
make down
make up
```

**WordPress not accessible:**

- Check if containers are running: `make ps`
- Check logs: `make logs`
- Verify port 8080 is not in use

**Xdebug not working:**

- Ensure port 9003 is not blocked
- Check IDE Xdebug configuration
- Verify path mappings are correct

**File changes not reflecting:**

- Check volume mounts in `docker-compose.yml`
- Restart container: `make restart`

**Database connection issues:**

- Wait for database to be ready: `make logs-db`
- Check database credentials in `.env`

## Contributing

We welcome contributions! Here's how you can help:

### Reporting Issues

1. **Check existing issues** first to avoid duplicates
2. **Use the issue templates** when creating new issues
3. **Provide detailed information**:
   - Your operating system
   - Docker version
   - Steps to reproduce
   - Expected vs actual behavior
   - Relevant logs (`make logs`)

### Pull Requests

Before creating a pull request, please:

1. **Discuss your changes** by creating an issue first to get feedback
2. **Fork the repository**
3. **Create a feature branch**: `git checkout -b feature/amazing-feature`
4. **Make your changes** and test them thoroughly
5. **Commit your changes**: `git commit -m 'Add amazing feature'`
6. **Push to your branch**: `git push origin feature/amazing-feature`
7. **Open a Pull Request** referencing the discussion issue

## Keeping Up To Date (Sync with Template)

You can pull future improvements from this template without overwriting your
work.

### Recommended layout for easy updates

- Keep all your custom code under `src/**`
- Configure your settings in `.devcontainer/.env` (gitignored)

### Add upstream and rebase periodically

```bash
git remote add upstream https://github.com/supermodo/wp-devbox.git
git fetch upstream
git rebase upstream/master   # or: git pull --rebase upstream master
```

### Ensure your `src/**` always wins on merges (optional)

Add a `.gitattributes` rule so your local changes under `src/**` are kept during
merges/rebases:

```gitattributes
src/** merge=ours
```

Enable the merge driver once per repo:

```bash
git config merge.ours.driver true
```

Side effects: upstream changes under `src/**` will not be merged automatically;
your local `src/**` always wins. Review upstream diffs before rebasing if
needed.

Alternatively, keep theme/plugin as separate repositories and include them here
as Git submodules under `src/` for full isolation from infra changes.

## Credits

Inspired by
[valenvb's vscode-devcontainer-wordpress](https://github.com/valenvb/vscode-devcontainer-wordpress).
