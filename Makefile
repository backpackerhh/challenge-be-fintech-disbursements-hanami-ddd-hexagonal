APP_ENV := development
DB_NAME := challenge_be_fintech_disbursements_$(APP_ENV)
DB_USER := postgres
TEST_PATH := spec
IMAGE_USERNAME := backpackerhh
IMAGE_TAG := challenge-be-fintech-disbursements
IMAGE_REPOSITORY := backpackerhh/challenge-be-fintech-ruby
IMAGE_VERSION := 0.1.0

db-connect:
	@docker compose exec db psql -U $(DB_USER) -d $(DB_NAME)

db-generate-structure:
	@docker compose exec db pg_dump --schema-only -U $(DB_USER) $(DB_NAME) > db/structure.sql
	@echo "DB structure generated"

db-generate-dump:
	@docker compose exec db pg_dump -U $(DB_USER) $(DB_NAME) > db/dump.sql
	@echo "DB dump generated"

db-restore:
	for table in $$(docker compose exec -T db psql -U $(DB_USER) -d $(DB_NAME) -Atc "SELECT tablename FROM pg_tables WHERE schemaname = 'public';"); do \
		docker compose exec -T db psql -U $(DB_USER) -d $(DB_NAME) -c "ALTER TABLE $$table DISABLE TRIGGER ALL;"; \
	done

	docker compose exec -T db psql -U $(DB_USER) -d $(DB_NAME) < db/dump.sql

	for table in $$(docker compose exec -T db psql -U $(DB_USER) -d $(DB_NAME) -Atc "SELECT tablename FROM pg_tables WHERE schemaname = 'public';"); do \
		docker compose exec -T db psql -U $(DB_USER) -d $(DB_NAME) -c "ALTER TABLE $$table ENABLE TRIGGER ALL;"; \
	done

	@echo "DB restored"

db-create:
	@docker compose exec -T db psql -U $(DB_USER) -c "CREATE DATABASE $(DB_NAME);"

db-migrate:
	@docker compose exec app rake db:migrate HANAMI_ENV=$(APP_ENV)

db-reset:
	@docker compose exec app rake db:reset HANAMI_ENV=$(APP_ENV)

db-generate-migration:
	@docker compose exec app rake db:create_migration\[$(NAME)\]

db-import-data:
	@docker compose exec app rake fintech:merchants:import\[db/data/merchants.csv\]
	@docker compose exec app rake fintech:orders:import\[db/data/orders.csv\]

db-generate-data:
	@docker compose exec app rake fintech:generate_data

db-generate-yearly-report:
	@docker compose exec app rake fintech:generate_yearly_report

start:
	@docker compose up --build -d $(SERVICES)

stop:
	@docker compose stop

restart:
	make stop
	make start

destroy:
	@docker compose down

install:
	@docker compose exec app bundle install

console:
	@docker compose exec app hanami console

test:
	@docker compose exec app rspec ${TEST_PATH}

lint:
	@docker compose exec app rubocop

logs:
	@docker compose logs $(SERVICE) -f

tasks:
	@docker compose exec app rake -vT

publish-image:
	@docker login -u $(IMAGE_USERNAME)
	@docker build -t $(IMAGE_TAG) -f Dockerfile.dev .
	@docker tag $(IMAGE_TAG):latest $(IMAGE_REPOSITORY):$(IMAGE_VERSION)
	@docker push $(IMAGE_REPOSITORY):$(IMAGE_VERSION)
