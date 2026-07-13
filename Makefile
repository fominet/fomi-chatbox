.PHONY: build stop start prune all

all: build stop start prune

build:
	docker compose -f docker-compose.production.yaml build --no-cache

stop:
	docker compose -f docker-compose.production.yaml down

start:
	docker compose -f docker-compose.production.yaml up -d

prune:
	docker system prune -a -f
