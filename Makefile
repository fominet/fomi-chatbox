.PHONY: build stop start-db setup start prune all

all: build stop start-db setup start prune

build:
	docker compose -f docker-compose.production.yaml build --no-cache

stop:
	docker compose -f docker-compose.production.yaml down

start-db:
	docker compose -f docker-compose.production.yaml up -d postgres redis

setup:
	docker compose -f docker-compose.production.yaml run --rm rails bundle exec rails db:create db:migrate

start:
	docker compose -f docker-compose.production.yaml up -d

prune:
	docker system prune -a -f
