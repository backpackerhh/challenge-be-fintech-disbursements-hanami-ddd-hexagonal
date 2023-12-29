# Backend coding challenge - Fintech

## Steps

* Add .ruby-version file specifying latest Ruby version: 3.2.2
* Create new application -> hanami new fintech
* Add Docker files:
  * Add Dockerfile -> build -t challenge-be-fintech-disbursements -f Dockerfile.dev .
  * Add docker-compose.yml
* Add .env.sample file -> add instructions and specify default values in the README
* Configure Postgres:
  * Add Postgres password to .env file
  * docker compose exec db psql -U postgres
  * CREATE DATABASE challenge_be_fintech_disbursements_development;
  * CREATE DATABASE challenge_be_fintech_disbursements_test;
* Remove configuration to start Hanami server (seems to be unneccessary for this app)
* Add RuboCop linter:
  * rvm @global do gem install rubocop rubocop-rspec rubocop-performance
  * Fix all offenses found
  * Some offenses are just disabled
  * Enforce "double_quotes" style -> not really a preference, simply to comply with code provided by Hanami
* Investigate about Hanami Model -> https://github.com/hanami/model (Deprecated)
* Investigate about Hanami slices
* Add merchant scaffolding
* Integrate Ruby LSP + RuboCop in codium:
  * Use an external Gemfile including only ruby-lsp and rubocop* gems
  * Configure the VSCodium extension so it points to that Gemfile
  * Restart the editor (just in case)
  * New code snippets are available
* Solve .env issue in containers -> remove env_file attribute from docker-compose.yml
* Create migration for merchants table:
  * docker exec -it rake db:create_migration\[create_merchants\]
  * docker exec -it rake db:migrate
  * docker exec -it rake db:migrate HANAMI_ENV=test
  * docker compose exec db psql -U postgres
  * docker exec -it rake db:clean -> remove all tables
  * docker exec -it rake db:reset -> remove all tables and re-runs migrations
  * Enable extension UUID
  * Create enum type for merchants' disbursement frequency column
* Check merchants relation in the console:
  * Map results in the repository to entities before return them
* Add validations to value objects
* Figure out how to save records -> insert, multi_insert
* Investigate about persistence with ROM
* Investigate about integrate Sidekiq with Hanami
  * https://github.com/sidekiq/sidekiq/wiki/API
* Investigate about Dry gems (system, container, auto_inject, struct, types)
* Raise custom exception with invalid argument error in value objects
* Raise custom exception with invalid repository implementation error in use cases
* Add interface for merchant repository
* Inject default merchant repository implementation in use case
* Change merchant's minimum monthly fee to decimal
* Define tests strategy according to Codely
* Investigate how to apply object mothers to Ruby using ROM::Factory
* Integrate Redis and Sidekiq
* Add scaffold to add and test custom Rake tasks in Hanami
* Follow TDD approach to develop needed code for importing merchants
  * Add jobs tests to ensure their configuration is correct
* Get database schema:
  * docker compose exec db pg_dump --schema-only -U postgres challenge_be_fintech_disbursements_development >! db/structure.sql
* Get database dump:
  * docker compose exec db pg_dump -U postgres challenge_be_fintech_disbursements_development >! db/dump.sql
* I'll take the liberty of replacing order IDs with random generated UUIDs:
  * For the sake of this challenge, it's just easier to keep all IDs as UUIDs
  * Don't do it in production!
* Add acceptance tests for orders
* Extract duplication from existing Rake tasks
* Investigate how to parallelize the import of orders with SmarterCSV
* Add unit tests for orders
* Create migration for orders table
* Add integration tests for orders repository
* Investigate how to get disbursement weekday from the live_on column on merchants:
  * https://stackoverflow.com/questions/41181990/extract-day-of-week-from-date-field-in-postgresql-assuming-weeks-start-on-monday
  * SELECT *, DATE_PART('isodow', live_on) AS disbursement_weekday FROM merchants;
  * SELECT *, TO_CHAR(live_on, 'Day') AS disbursement_weekday FROM merchants;
  * SELECT *, (SELECT CASE WHEN disbursement_frequency = 'DAILY' THEN 'All' ELSE TO_CHAR(live_on, 'Day') END) AS disbursement_weekday FROM merchants;
* Add Makefile with DB-related commands
* Add migration to add disbursements table
* Model disbursements
* Add migration to add disbursement_id to orders table
* Investigate about in memory event bus to create an order commission when an order is created
* Add migration to add order commissions table
* Model order commissions
* List every inheritance and analyze whether they are needed or not (section below)
* Implement a basic in memory event bus
* Publish event when merchant is created
* Investigate about passing plain objects (JSON) between layers in event bus
  * Add de/serializer for other event buses different to in-memory event bus
* Publish event when order is created
* Investigate how to test the flow event bus to event subscriber and use case
  * Event subscriber as unit tests -> injects use case, that receives its dependencies injected as well
* Consider whether order commission should be included in order aggregate root or not -> NOT NOW
* Investigate how to create acceptance test for the flow with subscriber and use case derived from a domain event
  * Unit test for the in memory event bus
  * Acceptance test for the event subscriber
* Add async event bus -> SidekiqEventBus
* Subscribe order commission to order created event
* Publish event when order commission is created
* Create order commissions when event is published
  * Be extremely careful with money calculations
* Add Sidekiq scheduler for recurring jobs
  * Add cron to run Rake task every morning at 7am -> disbursements queue
* Add migration to add start_date and end_date columns to disbursements table
* Remove unnecessary FQN from entity factories
* Allow to specify time in which it should be frozen in tests
* Add acceptance tests for generate disbursements related stuff
* Add unit tests for generate disbursements related stuff
* Add integration tests for generate disbursements related stuff
* Publish event to update corresponding orders when a disbursement is created -> Eventual consistency
* Add missing indexes to disbursements, orders and order_commissions tables
* Add migration to add monthly fees table
* Model monthly fees
* Update acceptance test for start processing disbursements to take into account monthly fees
* Add unit tests for logic related to monthly fees
* Add integration tests for logic related to monthly fees
* Improve logic to create monthly fees
* Find out how to generate disbursements for every day of the week (weekly disbursed merchants)
  * Rake task -> OTT (one time task)
* Generate dump with all records
* Add new commands to Makefile
* Add custom exception to repositories
  * Add database exception handler
* Upload image to Docker Hub:
  * Add .dockerignore
  * docker build -t challenge-be-fintech-disbursements -f Dockerfile.dev .
  * Create new repository -> backpackerhh/challenge-be-fintech-ruby
  * Add image tag -> docker tag challenge-be-fintech-disbursements:latest backpackerhh/challenge-be-fintech-ruby:0.1.0
  * Log in -> docker login -u backpackerhh
  * Push image -> docker push backpackerhh/challenge-be-fintech-ruby:0.1.0
  * Update docker-compose.yml to use new image
