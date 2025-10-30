PROJECT?=wp-devbox
COMPOSE=docker compose -p $(PROJECT) -f .devcontainer/docker-compose.yml
SERVICE=wordpress

.PHONY: help setup up down clean logs shell shell-vscode wp restart rebuild ps

.DEFAULT_GOAL := help

# Catch-all target to handle unknown targets
%:
	@echo "\033[1;31mUnknown target '$*'. Showing help:\033[0m"
	@echo ""
	@make help

help:
	@echo "╔════════════════════════════════════════════════════════════════════╗"
	@echo "║                    WP-DEVBOX Makefile Commands                     ║"
	@echo "╚════════════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "\033[1;33m┌─ Project Setup & Maintenance \033[0m"
	@echo "\033[1;33m│\033[0m  setup              \033[90m- Initial project setup (create env files)\033[0m"
	@echo "\033[1;33m│\033[0m  clean              \033[90m- Stop containers and remove volumes\033[0m"
	@echo "\033[1;33m└─\033[0m"
	@echo ""
	@echo "\033[1;32m┌─ Docker Management \033[0m"
	@echo "\033[1;32m│\033[0m  up                 \033[90m- Start all containers\033[0m"
	@echo "\033[1;32m│\033[0m  down               \033[90m- Stop all containers\033[0m"
	@echo "\033[1;32m│\033[0m  restart            \033[90m- Restart WordPress container\033[0m"
	@echo "\033[1;32m│\033[0m  rebuild            \033[90m- Rebuild and restart WordPress container\033[0m"
	@echo "\033[1;32m│\033[0m  logs               \033[90m- Show WordPress container logs\033[0m"
	@echo "\033[1;32m│\033[0m  logs-tail          \033[90m- Show WordPress container logs with tail 200 lines\033[0m"
	@echo "\033[1;32m│\033[0m  logs-db            \033[90m- Show database container logs\033[0m"
	@echo "\033[1;32m│\033[0m  logs-mailhog       \033[90m- Show mailhog container logs\033[0m"
	@echo "\033[1;32m│\033[0m  ps                 \033[90m- Show running containers\033[0m"
	@echo "\033[1;32m└─\033[0m"
	@echo ""
	@echo "\033[1;35m┌─ WordPress Development \033[0m"
	@echo "\033[1;35m│\033[0m  shell              \033[90m- Access WordPress container shell\033[0m"
	@echo "\033[1;35m│\033[0m  shell-vscode       \033[90m- Access WordPress container as vscode user\033[0m"
	@echo "\033[1;35m│\033[0m  wp                 \033[90m- Run WP-CLI commands (usage: make wp cmd=\"command\")\033[0m"
	@echo "\033[1;35m└─\033[0m"

setup:
	@echo "Setting up development environment..."
	@if [ ! -f .devcontainer/.env ]; then \
		cp .devcontainer/.env.example .devcontainer/.env; \
		echo "✅ Created .devcontainer/.env from .env.example"; \
	else \
		echo "✅ .devcontainer/.env already exists"; \
	fi
	@echo "✅ Development environment ready!"
	@echo "💡 Customize .devcontainer/.env if needed, then run 'make up'"

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v

logs:
	$(COMPOSE) logs -f $(SERVICE)

logs-tail:
	$(COMPOSE) logs -f --tail=200 $(SERVICE)

logs-db:
	$(COMPOSE) logs -f db

logs-mailhog:
	$(COMPOSE) logs -f mailhog

shell:
	$(COMPOSE) exec $(SERVICE) bash

shell-vscode:
	$(COMPOSE) exec -u vscode $(SERVICE) bash

wp:
	$(COMPOSE) exec -u www-data $(SERVICE) wp $(cmd)

restart:
	$(COMPOSE) restart $(SERVICE)

rebuild:
	$(COMPOSE) build --no-cache $(SERVICE) && $(COMPOSE) up -d $(SERVICE)

ps:
	$(COMPOSE) ps
