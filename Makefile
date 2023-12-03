HANAMI_ENV := development
DB_NAME := challenge_be_fintech_disbursements_$(HANAMI_ENV)
DB_USER := postgres

db-connect:
	@docker compose exec db psql -U $(DB_USER) -d $(DB_NAME)

db-generate-structure:
	@docker compose exec db pg_dump --schema-only -U $(DB_USER) $(DB_NAME) > db/structure.sql
	@echo "DB structure generated"

db-generate-dump:
	@docker compose exec db pg_dump -U $(DB_USER) $(DB_NAME) > db/dump.sql
	@echo "DB dump generated"

db-restore:
	@docker compose exec -T db psql -U $(DB_USER) -d $(DB_NAME) < db/dump.sql
	@echo "DB restored"