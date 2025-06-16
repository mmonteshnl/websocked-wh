.PHONY: help start up down restart logs status clean backup restore

help: ## Show this help message
	@echo 'N8N Complete Project - Comandos disponibles:'
	@echo ''
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  %-20s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

start: ## Start all services with automatic setup (RECOMENDADO)
	@./start.sh

up: ## Start all services
	docker-compose up -d

down: ## Stop all services
	docker-compose down

restart: ## Restart all services
	docker-compose restart

logs: ## Show logs for all services
	docker-compose logs -f

logs-n8n: ## Show N8N logs only
	docker-compose logs -f n8n

logs-postgres: ## Show PostgreSQL logs only
	docker-compose logs -f postgres

logs-evolution: ## Show Evolution API logs only
	docker-compose logs -f evolution-api

status: ## Show status of all services
	docker-compose ps

clean: ## Remove all containers and volumes (WARNING: This will delete all data!)
	docker-compose down -v
	docker system prune -f

backup: ## Backup PostgreSQL database
	docker exec n8n_postgres pg_dump -U $$(grep POSTGRES_USER .env | cut -d '=' -f2) $$(grep POSTGRES_DB .env | cut -d '=' -f2) > backup_$$(date +%Y%m%d_%H%M%S).sql

restore: ## Restore PostgreSQL database (Usage: make restore FILE=backup_file.sql)
	@if [ -z "$(FILE)" ]; then echo "Usage: make restore FILE=backup_file.sql"; exit 1; fi
	docker exec -i n8n_postgres psql -U $$(grep POSTGRES_USER .env | cut -d '=' -f2) $$(grep POSTGRES_DB .env | cut -d '=' -f2) < $(FILE)

shell-n8n: ## Access N8N container shell
	docker exec -it n8n /bin/sh

shell-postgres: ## Access PostgreSQL container shell
	docker exec -it n8n_postgres /bin/bash

shell-evolution: ## Access Evolution API container shell
	docker exec -it evolution_api /bin/bash

update: ## Update all images to latest versions
	docker-compose pull
	docker-compose up -d