.PHONY: build stop start-db setup start prune all

all: build stop start-db setup start prune

build:
	docker compose -f docker-compose.production.yaml build --no-cache

stop:
	docker compose -f docker-compose.production.yaml down

start-db:
	docker compose -f docker-compose.production.yaml up -d postgres redis

setup:
	docker compose -f docker-compose.production.yaml run --rm rails sh -c "ruby -e '
  path = Dir.glob(\"/app/db/migrate/*add_cached_labels_list*\").first
  next unless path
  content = File.read(path)
  new_content = content.gsub(
    /ActsAsTaggableOn::Taggable::(Cache|CacheKeys)\.included\(Conversation\)/,
    "begin\n      ActsAsTaggableOn::Taggable::Cache.included(Conversation)\n    rescue NameError\n      # acts-as-taggable-on removed this module; column already added above\n    end"
  )
  File.write(path, new_content)
' && bundle exec rails db:create db:migrate"

start:
	docker compose -f docker-compose.production.yaml up -d

prune:
	docker system prune -a -f
