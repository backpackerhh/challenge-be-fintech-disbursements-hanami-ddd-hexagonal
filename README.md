# Fintech - Backend challenge

## Up and running

Clone repository from GitHub:

```bash
$ git clone git@github.com:backpackerhh/challenge-be-fintech-disbursements.git
```

Go to the project directory:

```bash
$ cd challenge-be-fintech-disbursements
```

Start database container in the background:

```bash
$ make start SERVICES=db
```

Create development database:

```bash
$ make db-create
```

Download dump file from [this link](https://drive.google.com/file/d/1oDQ_MYaQTB24a7ize99albFhjexI4tF2/view?usp=drive_link) and store it in `db/dump.sql`.

Restore database:

```bash
$ make db-restore
```

Start rest of containers in the background:

```bash
$ make start
```

Create test database:

```bash
$ make db-create APP_ENV=test
```

Run migrations in test environment:

```bash
$ make db-migrate APP_ENV=test
```

Run test suite:

```bash
$ make test
```

Run linter:

```bash
$ make lint
```

Take a look at `Makefile` to see other commands available.

## Code

The code in this challenge has been highly inspired by the people of [Codely](https://codely.com/). In case you don't know them, in their courses they teach you how to apply best practices to code, aiming to achieve better maintenability, scalability and testability.

I'll tell you more in next sections.

### Technical choices

In every case, I'm using the latest stable version at the moment of writing.

#### Programming language

[Ruby 3.2.2](https://www.ruby-lang.org/en/news/2023/03/30/ruby-3-2-2-released/)

#### Framework

[Hanami 2.0.3](https://hanamirb.org/blog/2023/02/01/hanami-203/)

Although I'm quite experienced in [Rails](https://rubyonrails.org/), I rather prefered to use a lighter framework, so I chose [Hanami](https://hanamirb.org/) instead.

I must say I've learnt Hanami along the way and it wasn't as easy as I could expect, because there isn't much documentation about this major release yet.

#### Database

[PostgreSQL 16](https://www.postgresql.org/about/news/postgresql-16-released-2715/)

#### Background jobs

[Sidekiq 7](https://www.mikeperham.com/2022/10/27/introducing-sidekiq-7.0/)

#### Containers

[Docker 24](https://docs.docker.com/engine/release-notes/24.0/) + [docker compose 2](https://docs.docker.com/compose/release-notes/#2210)

An [image](https://hub.docker.com/r/backpackerhh/challenge-be-fintech-ruby/tags) is uploaded to Docker Hub and used for building and running this project.

#### Dependencies

Hanami, by its own nature, depends on other well established gems in the Ruby community, such as [rom-rb](https://github.com/rom-rb/rom), [Sequel](https://github.com/jeremyevans/sequel) and [dry-rb](https://github.com/dry-rb).

Other than that, I've tried to keep external dependencies to a minimum.

Every time a new dependency has been added, details about it were included in the relevant commit.

### Architecture

#### Domain-Driven Design (DDD)

The **strategical design** can't be properly applied here without access to *domain experts*.

That means that there is no *ubiquitous language* defined, so I've used the names specified in the instructions.

No *bounded context* has been defined either, although with the information included in the instructions I could have assumed the context is payments or something similar.

Being that the case, instead of having current namespaces, it'd be enough adding a new nested module:

```ruby
# Before

module Fintech
  module Merchants
    module Domain
      class MerchantEntity
      end
    end
  end
end

# After

module Fintech
  module Payments
    module Merchants
      module Domain
        class MerchantEntity
        end
      end
    end
  end
end
```

For that reason, I've only applied the **tactical design** in this challenge, making use of the following building blocks:

* **Entities** and **value objects** to define *aggregates*, with their respective *aggregate root*.
* **Repositories** to interact with external resources.
* **Factories** to encapsulate the creation of entities and domain events.
* **Application services** to represent *use cases*, being the entry points to the application.
* **Domain services** to reuse some domain logic and/or inject them in other collaborator objects.
* **Domain events** to notify about changes in the application.

#### Hexagonal Architecture (Ports and Adapters)

The code is organized using a *layered architecture*, where the outer layers can use code from the inner layers, but not the other way around.

In addition, the code is structured using **vertical slicing**, where each module contains a directory per layer.

The benefit of this approach is a code better organized, less indirection and, in case of wanting to promote a module to a bounded context later on, the code will be easier to extract.

Example:

Without vertical slicing

```bash
lib/
  fintech/
    application/
      disbursements/
        ...
      merchants/
        ...
      shared/
        ...
    domain/
      disbursements/
        ...
      merchants/
        ...
      shared/
        ...
    infrastructure/
      disbursements/
        ...
      merchants/
        ...
      shared/
        ...
```

With vertical slicing

```bash
lib/
  fintech/
    disbursements/
      application/
        ...
      domain/
        ...
      infrastructure/
        ...
    merchants/
      application/
        ...
      domain/
        ...
      infrastructure/
        ...
    shared/
      ...
```

The list of objects in every layer in this challenge is as follows:

* **infrastructure**: background jobs, adapters (repository, event bus), serializers, relations, errors*
* **application**: application services (use cases), adapters (event subscriber), errors*
* **domain**: entities, value objects, ports (repository, event bus, event subscriber), events, domain services, test factories, errors*

To be honest, it's not very clear to me where should be placed every error class, so for the lack of a better approach, I'd consider moving them to the layer where they are called from.

#### Event-Driven Architecture

In every use case with side effects, a domain event is published to an event bus. In this application there are 2 different implementations:

* **In-memory**: sync, the event is published on reception.
* **Sidekiq**: async, the event is enqueued in a dedicated queue for later publication.

The default event bus is the in-memory implementation.

An event received in the async event bus is serialized, in compliance with Sidekiq's expectations regarding job arguments, and once the corresponding job is processed, the event is deserialized to build a new domain event in memory with the same values before publishing it.

The format of the event received before serialization is validated using JSON Schema.

The name of every event is in the past, such as *MerchantCreatedEvent*, *DisbursedOrdersUpdatedEvent*...

Note that some events don't have subscribers, but they are published anyway. It's definitely something that could happen in a real project.

For illustrative purposes only, events are indistinctly published to the sync or the async bus.

### Tasks

Import merchants and orders:

```bash
$ make db-import-data
```

That command is calling two separated Rake tasks under the hood.

For the sake of this challenge, a task has been added to generate disbursements for all existing merchants, not only those that should be disbursed in the current day:

```bash
$ make db-generate-data
```

Generate a yearly report:

```bash
$ make db-generate-yearly-report
```

Check a [section below](#yearly-report) about that report to see the output of that command.

In addition, I'm using a Sidekiq extension, [sidekiq-scheduler](https://github.com/sidekiq-scheduler/sidekiq-scheduler), to run the job that generates disbursements and monthly fees at 07:00 UTC daily. Instructions said that the process must be completed by 08:00 UTC, so I'm running the process with enough time, although it should be fast enough so the time to run could be adjusted if needed.

That extension directly calls a job, that is configured in `config/sidekiq.yml`:

```yaml
:scheduler:
  :schedule:
    generate_disbursements:
      description: 'Start process to generate disbursements (and monthly fees)'
      cron: '0 0 7 * * * UTC' # Every day at 07:00:00 UTC
      class: Fintech::Disbursements::Infrastructure::GenerateDisbursementsJob
```

### Decisions

* Code in `lib` instead of `app` or creating any [slices](https://guides.hanamirb.org/v2.0/app/slices/):
  * No particular reason, it was a decision made after reading Hanami guides.
* Every file include its type in the filename: `CreateDisbursementJob`, `CreateDisbursementUseCase`, `DisbursementEntity`, `DisbursementIdValueObject`, ...
* Constructor is private for aggregate roots and events, so `.from_primitives` factory method must be used instead.
* Value objects only include `value` attribute, so any possible calculation needed would be performed in the constructor of the aggregate root as part of the default value of the related attribute.
* Some RuboCop cops are just disabled for certain files:
  * Although it'd be a team decision, personally I prefer to explicitly disable cops in `.rubocop.yml` file, instead of doing it inline in every file.
  * Usually I've worked with single quotes, but here I chose double quotes instead.
  * I avoid conditional modifiers at the end of the lines. If there is a condition, I prefer to see it upfront.
  * I completely avoid the use of `unless` in Ruby, whenever possible. IMHO, it adds a cognitive load in most cases.
  * I like guard clauses, although in this code you'll find very few.
* Use individual creation of records (merchants, orders) instead of bulk creation:
  * Mainly because I didn't want to handle here any possible exception raised for any of those records created at once.
* Instead of using IDs present in the CSV file, I'm using UUIDs to identify orders.
* UUIDs are always generated for the application instead of delegating that generation to the database.
* Use cases only receive and use a finder service from another module, basically to check that an associated object exists.
* The length of disbursements' reference is 12 alphanumeric characters, generated randomly.
* For storing and doing some operations with money I decided to use decimals:
  * Obviously using float was not an option, as is not recommended, but I discarded using integers as well.
* The code is ready to generate disbursements for orders from the past, included in the CSV file, and for new orders:
  * Orders are disbursed exactly once, as they keep a reference to the associated disbursement, that is eventually updated after the disbursement is created:
    * In a first approach a database function and a trigger were used to update those records ([b28833f](https://github.com/backpackerhh/challenge-be-fintech-disbursements/commit/b28833fdbb21d8efedf213b3aab8c3375f837bba)).
    * In a second approach, as the previous one caused high coupling with the database, those records are updated using domain events.
  * Those merchants whose disbursement frequency is weekly will receive disbursements from Monday to Sunday of a given week.
* I use the term commission to refer to the quantity that is charged to a merchant after applying a fee. I based that decision on [this answer](https://www.quora.com/What-is-the-difference-between-commission-and-fees), due to not having a domain expert that could confirm the right names.
* Order commissions could be included in the order aggregate root, but I kept them as separate entities:
  * In some repositories however I'm joining both tables to get desired data.
* Due to current requirements, monthly fees are created after the first disbursement of the month for a given merchant. That logic would need to change for sure whenever the monthly fee needs to be substracted from the disbursement amount.
* Monthly fees are not created for merchants in the same month they go live in the platform. The first one is created in their next month.
* Value objects and uses cases (maybe any other files as well) use functionality provided by *dry-rb*:
  * Although it's formed by a set of external libraries, therefore you could think it belongs to the **infrastructure** layer, I consider it as it was part of the Ruby language itself in this code.
  * Being that way, it could be used anywhere in the code, including **application** and **domain** layers. It's something that the team can agree upon.
  * Typing and dependency injection are the two functionality more used regarding those libraries.
* Although I'm not implementing CQRS, I avoid commands (create, update...) returning any value.
* Some columns are denormalized, such as `order_ids` in disbursements or `order_amount` in order commissions.
* On purpose tests are kept to a minimum:
  * The goal was having great confidence in the test suite, avoiding changes in tests as much as possible when some implementation detail changed.
  * Another goal was avoiding duplicate tests where the same functionality is tested again and again in different kind of tests.
* Use domain events to notify about changes in the application.
* All implementations of Postgres repositories include a database exception handler module:
  * Any exception from Sequel is rescued and a custom exception is raised instead.
* Due to the lack of interfaces in Ruby, I've used class methods to dynamically enforce injected dependencies respond to expected methods (*dry-auto_inject* + *dry-types*).

### Testing

In this challenge I've followed as much as possible an **Outside-In Test-Driven Development** approach. It leverages the same *red, green, refactor* steps than TDD, but starting from the outside of the application and going inwards.

In short, the process is something like this:

* Add an acceptance test, that should be failing for the expected reason, e.g. a record not being created.
* Add a unit test, that should be failing for the expected reason. Use mocks where needed.
* Add code to make the unit test pass.
* Follow the TDD cycle as many times as needed.
* Add integration tests for implementations of repositories.
* Add code to make the integration tests pass.
* The acceptance test should be passing now.

That testing approach is the one recommended by Codely in their courses and I felt quite comfortable doing things that way.

Usually I'd have tested everything with a mix of unit and integration tests, maybe adding an acceptance test here and there, but probably the approach followed here once mastered could be the one I like the most.

#### Acceptance tests

This kind of tests work like **e2e** tests, as they are testing an entire entry point in the application (Rake task, event subscriber, ...), from start to finish.

These are the tests that give you more confidence about the code, but at the same time are the slowest tests.

**Black box testing** is applied, so any small change in the code does not have to imply a change in the tests as well.

At this point basically the happy path is tested. Nothing is being done with any possible exception that could be raised, so in other tests is tested that those exceptions are actually being raised.

Some [RSpec hooks](https://rspec.info/documentation/3.12/rspec-core/RSpec/Core/Hooks.html) are used to configure examples:

* *fake_event_bus*: the dependency key must be provided. This is the only mock/stub used in these tests, so no endless process is tested, where an event is published, a subscriber receives it and then another event is published, and so on.
* *sidekiq_inline*: a Sidekiq job that is part of the process is immediately executed.
* *freeze_time*: the desired time object must be provided.

##### Import merchants task

Some tests check the argument received is an existing CSV file.

Another test checks all merchants are properly created.

##### Import orders task

Some tests check the argument received is an existing CSV file.

Another test checks all orders are properly created.

##### Generate disbursements and monthly fees job

Checks basic job configuration (unit test).

Checks expected disbursements and monthly fees for disbursable merchants are created based on the current time in the test and the data present in the database.

The Sidekiq scheduler directly calls this job instead of doing it through a Rake task, as usually could happen with other options such as [whenever](https://github.com/javan/whenever). For that reason, this is the entry point to this functionality.

##### Generate disbursements and monthly fees task

The functionality is exactly the same than the one for the previous job, except that it's applied for all merchants.

It's a task that is meant to run only once.

For that reason, the test only checks that expected jobs are enqueued for every merchant created.

##### Create order commission on order created event subscriber

Checks it's included in the list of event subscribers and checks the list of events it's subscribed to (unit tests).

Checks an order commission is created using the event received.

##### Update disbursed orders on disbursed created event subscriber

Checks it's included in the list of event subscribers and checks the list of events it's subscribed to (unit tests).

Checks all orders associated to the created disbursement are updated with the reference to that disbursement.

#### Integration tests

Focused here in repositories.

Checks every edge case that comes to mind, such as returning an empty collection, a collection with expected results, creation with and without errors, etc.

#### Unit tests

The main difference here is what it's considered a unit.

Probably most people would consider a class or a method is a unit, but in this case, following once again the teachings of Codely, the use case is the one that is considered a unit.

Any collaborator object is mocked, such as the event bus or the repository.

Checks every edge case that comes to mind, such as creation with and without valid attributes, exceptions raised for every attribute, etc.

In addition, checks jobs configuration, the list of event subscribers and the list of events an event subscriber is subscribed to. Sorry for the tongue twister.

#### Factories

All factories are encapsulated in domain objects placed in `spec/support/fintech`, following a similar structure than production objects in `lib/fintech`.

No associations have been added in factories, so all created records are explicitly defined in every spec.

[ROM Factory](https://rom-rb.org/learn/factory/0.10/) is used to define every entity factory and some attributes of those factories internally use [Faker](https://github.com/faker-ruby/faker) to define a default value.

#### Other details

* I embrace [WET tests](https://thoughtbot.com/blog/the-case-for-wet-tests).
* `Date.today` is used instead of `CURRENT_DATE` in queries so the time can be frozen in the date I need it to be.
* Some fake objects are placed in `spec/support/fintech`.
* In some files I've added multiple expectations in the same example, checking the state of the database before and after some action.
* In the acceptance test for generating disbursements and monthly fees, there is a case where some order from a weekly disbursed merchant is discarded for a disbursement because it belongs to the present week, but its commissions amount counts as part of the total commissions.
* Maybe the unit test for importing data should be the job that enqueues another jobs instead of the use case.

### Performance

I tried to create efficient code and make all processes fast.

The execution times of certain queries improved a lot with the addition of column indexes, but sometimes making the queries simpler did the trick.

Next I'll show some examples.

#### Import orders

This is the heaviest process, as it has to import +1.3M rows from a CSV file.

Definitely, I couldn't go with a naive approach like the one for merchants (50 rows), where the whole file is loaded into memory and for each line in the file a job is enqueued to import the merchant.

For that reason, I use [SmarterCSV](https://github.com/tilo/smarter_csv) gem, that allows to load a file in chunks and for each one of those chunks it enqueues a job to import an order.

Besides, the use of `Sidekiq::Client.push_bulk` cuts down on the Redis round trip latency.

In a first attempt, simply importing orders, the process took around 1h45min.

In a second attempt, importing orders, publishing the corresponding domain event to the async bus and processing the job to create the corresponding order commission took around 4h20min. That's why I've included a link to a dump file that allows to restore the database in around 2 minutes.

For sure, importing all orders synchronously would have taken less time, but I wanted to do it as the code was ready for production.

#### Generate disbursements and monthly fees for all merchants

Initially, the whole process to generate all those records was running in the same Sidekiq queue with low concurrency.

That process should run only once and includes following steps:

* Finding all merchants.
* Grouping all orders for each merchant according to their disbursement frequency (daily or weekly).
* Creating disbursements for each of those groups of orders.
* Creating monthly fees for every first disbursement of the month for a given merchant.

After running that process the first time, apparently everything was working fine because not a single job failed. However, I felt that very few monthly fees had been created.

I removed all records and re-run the same process again. That second time even less monthly fees were created.

So I decided to apply some improvements to that process:

* Add certain interval between jobs enqueued to create disbursements.
* Tune the amount of concurrency in Sidekiq processess (from 5 to 10 in development environment).
* Use a dedicated queue for monthly fees.

After those changes, everything worked as expected. You can find more details in the relevant commits.

Note that, in a daily basis, the same process runs only for disbursable merchants.

#### Check if only a disbursement exists in the month for a merchant

This is a query that will be executed every time a disbursement is created, so it's important that it's fast.

##### First attempt

```sql
EXPLAIN ANALYZE
SELECT EXISTS (
  SELECT 1
  FROM disbursements
  WHERE merchant_id = '9332a4b0-f457-427e-8087-63dfb5ffc719'
  AND start_date >= DATE(DATE_TRUNC('month', DATE('2022-10-14')))
  AND end_date < DATE(DATE_TRUNC('month', DATE('2022-10-14')) + INTERVAL '1 month');
);
```

###### Result without indexes

```sql
Result  (cost=178.74..178.75 rows=1 width=1) (actual time=3.043..3.044 rows=1 loops=1)
   InitPlan 1 (returns $0)
     ->  Seq Scan on disbursements  (cost=0.00..893.68 rows=5 width=0) (actual time=3.042..3.042 rows=0 loops=1)
           Filter: ((merchant_id = '9332a4b0-f457-427e-8087-63dfb5ffc719'::uuid) AND (start_date >= date(date_trunc('month'::text, ('2022-10-14'::date)::timestamp with time zone
))) AND (end_date < date((date_trunc('month'::text, ('2022-10-14'::date)::timestamp with time zone) + '1 mon'::interval))))
           Rows Removed by Filter: 11468
 Planning Time: 0.122 ms
 Execution Time: 3.060 ms
```

##### Second attempt

```sql
EXPLAIN ANALYZE
SELECT COUNT(*)
FROM disbursements
WHERE merchant_id = '9332a4b0-f457-427e-8087-63dfb5ffc719'
AND start_date >= DATE_TRUNC('month', DATE('2022-10-14'))
AND end_date < (DATE_TRUNC('month', DATE('2022-10-14')) + INTERVAL '1 month');
```

###### Result with indexes

```sql
Aggregate  (cost=203.12..203.13 rows=1 width=8) (actual time=0.256..0.257 rows=1 loops=1)
   ->  Bitmap Heap Scan on disbursements  (cost=180.87..203.10 rows=6 width=0) (actual time=0.253..0.254 rows=0 loops=1)
         Recheck Cond: ((merchant_id = '9332a4b0-f457-427e-8087-63dfb5ffc719'::uuid) AND (start_date >= date_trunc('month'::text, ('2022-10-14'::date)::timestamp with time zone)
) AND (end_date < (date_trunc('month'::text, ('2022-10-14'::date)::timestamp with time zone) + '1 mon'::interval)))
         ->  BitmapAnd  (cost=180.87..180.87 rows=6 width=0) (actual time=0.251..0.252 rows=0 loops=1)
               ->  Bitmap Index Scan on disbursements_merchant_id_index  (cost=0.00..5.77 rows=198 width=0) (actual time=0.050..0.050 rows=198 loops=1)
                     Index Cond: (merchant_id = '9332a4b0-f457-427e-8087-63dfb5ffc719'::uuid)
               ->  Bitmap Index Scan on disbursements_start_date_end_date_index  (cost=0.00..174.85 rows=349 width=0) (actual time=0.192..0.192 rows=305 loops=1)
                     Index Cond: ((start_date >= date_trunc('month'::text, ('2022-10-14'::date)::timestamp with time zone)) AND (end_date < (date_trunc('month'::text, ('2022-10-
14'::date)::timestamp with time zone) + '1 mon'::interval)))
 Planning Time: 0.741 ms
 Execution Time: 0.346 ms
```

#### Sum of all order commissions amount in a month for a merchant

This is a query that will be executed every time a disbursement is the first in the month for the merchant.

##### First attempt

```sql
EXPLAIN ANALYZE
SELECT EXTRACT(YEAR FROM o.created_at) AS year,
       EXTRACT(MONTH FROM o.created_at) AS month,
       SUM(oc.amount) AS monthly_amount
FROM order_commissions oc
JOIN orders o
ON o.id = oc.order_id
WHERE o.merchant_id = '9332a4b0-f457-427e-8087-63dfb5ffc719'
AND EXTRACT(YEAR FROM o.created_at) = EXTRACT(YEAR FROM DATE('2022-09-14'))
AND EXTRACT(MONTH FROM o.created_at) = EXTRACT(MONTH FROM DATE('2022-09-14'))
GROUP BY year, month;
```

###### Result without indexes

```sql
Finalize GroupAggregate  (cost=1000.43..30849.78 rows=1 width=96) (actual time=102.959..109.751 rows=1 loops=1)
   ->  Gather  (cost=1000.43..30849.75 rows=2 width=40) (actual time=102.824..109.736 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial GroupAggregate  (cost=0.43..29849.55 rows=1 width=40) (actual time=98.354..98.356 rows=1 loops=3)
               ->  Nested Loop  (cost=0.43..29849.54 rows=1 width=13) (actual time=47.536..97.826 rows=2182 loops=3)
                     ->  Parallel Seq Scan on orders o  (cost=0.00..29841.09 rows=1 width=24) (actual time=47.498..86.491 rows=2182 loops=3)
                           Filter: ((merchant_id = '9332a4b0-f457-427e-8087-63dfb5ffc719'::uuid) AND (EXTRACT(year FROM created_at) = '2022'::numeric) AND (EXTRACT(month FROM cr
eated_at) = '9'::numeric))
                           Rows Removed by Filter: 434159
                     ->  Index Scan using order_commissions_order_id_key on order_commissions oc  (cost=0.43..8.45 rows=1 width=21) (actual time=0.005..0.005 rows=1 loops=6546)
                           Index Cond: (order_id = o.id)
 Planning Time: 0.240 ms
 Execution Time: 109.786 ms
```

#### Second attempt

```sql
EXPLAIN ANALYZE
SELECT SUM(oc.amount) AS monthly_amount
FROM order_commissions oc
JOIN orders o
ON o.id = oc.order_id
WHERE o.merchant_id = '9332a4b0-f457-427e-8087-63dfb5ffc719'
AND DATE(o.created_at) >= DATE_TRUNC('month', DATE('2022-09-14'))
AND DATE(o.created_at) < (DATE_TRUNC('month', DATE('2022-09-14')) + INTERVAL '1 month');
```

##### Result with indexes

```sql
 Aggregate  (cost=1278.69..1278.70 rows=1 width=32) (actual time=1.301..1.302 rows=1 loops=1)
   ->  Nested Loop  (cost=7.52..1278.68 rows=2 width=5) (actual time=1.297..1.298 rows=0 loops=1)
         ->  Bitmap Heap Scan on orders o  (cost=7.09..1261.79 rows=2 width=16) (actual time=1.296..1.297 rows=0 loops=1)
               Recheck Cond: (merchant_id = '9332a4b0-f457-427e-8087-63dfb5ffc719'::uuid)
               Filter: ((date(created_at) >= date_trunc('month'::text, ('2022-09-14'::date)::timestamp with time zone)) AND (date(created_at) < (date_trunc('month'::text, ('2022
-09-14'::date)::timestamp with time zone) + '1 mon'::interval)))
               Rows Removed by Filter: 297
               Heap Blocks: exact=61
               ->  Bitmap Index Scan on orders_merchant_id_index  (cost=0.00..7.09 rows=355 width=0) (actual time=0.065..0.065 rows=297 loops=1)
                     Index Cond: (merchant_id = '9332a4b0-f457-427e-8087-63dfb5ffc719'::uuid)
         ->  Index Scan using order_commissions_order_id_index on order_commissions oc  (cost=0.43..8.45 rows=1 width=21) (never executed)
               Index Cond: (order_id = o.id)
 Planning Time: 1.783 ms
 Execution Time: 1.358 ms
```

### Possible improvements

* Define the approach for the *strategical design* with domain experts.
* Consider some attributes or combination of attributes unique, at least with a database index:
  * merchants -> `email`
  * disbursements -> `merchant_id` + `start_date` [+ `end_date`]
  * monthly fees -> `merchant_id` + `month`
* Include `updated_at` columns in every table.
* The input CSV files could be validated.
* Add test examples in case of receiving an invalid CSV file.
* Use a Sidekiq PRO batch for processing orders.
* Setup Sidekiq Web if necessary:
  * Quite useful having a UI with information about queues, failing jobs, etc.
* Apply CQRS so queries and commands are clearly separated using a query bus and a command bus, respectively.
* Force referential integrity in disbursements' `order_ids` column:
  * https://github.com/jeremyevans/sequel_postgresql_triggers/blob/master/lib/sequel/extensions/pg_triggers.rb#L259
* Use of shared value object representing the same attribute, e.g. merchant's ID and order's merchant ID.
* Add pagination to method `.all` for order and order commission repositories.
* Add tests to check logger is called with expected arguments, only if strictly necessary.
* Add aggregate roots' class as part of the equality check besides the id.
* Include order commissions as part of the order aggregate root.
* Order and its commission could be created within a transaction, only if strictly necessary.
* Use a gem to handle money operations.
* Value objects factories could be named `ValueObjectFactory` instead of just `Factory` to be more consistent.
* Tackle certain cyclomatic complexity ignored in some files, where RuboCop was silenced.
* Remove unnecessary files from version control and/or the Docker image.
* Add logging and error handling in certain parts of the code that are now missing.
* Add some kind of monitoring tool, such as Prometheus or Datadog.
* Add some kind of CI/CD pipeline, such as GitHub Actions, GitLab or Jenkins.
* Add a test to ensure the expected job runs every day at 07:00 UTC to create disbursements and monthly fees.

## Yearly report

As requested in the instructions provided, the yearly report is included here:

| Year  | Number of disbursements | Amount disbursed to merchants | Amount of order fees | Number of monthly fees charged (From minimum monthly fee) | Amount of monthly fee charged (From minimum monthly fee) |
| :---: | :---------------------: | :---------------------------: | :------------------: | :-------------------------------------------------------: | :------------------------------------------------------: |
| 2022  |          1551           |        39,025,757.05 €        |     348,353.16 €     |                            31                             |                         562.83 €                         |
| 2023  |          10357          |       188,511,100.86 €        |    1,701,069.41 €    |                            104                            |                        1,735.65 €                        |

> Note that no other reference to currency will be found in this code.

## Conclusion

I put my heart and soul into this challenge. It took me my time to complete it, but in general terms I'd say I'm happy with the result.

Although I've worked in some projects where some *DDD-Lite* has been applied (as Vaughn Vernon calls it in the DDD red book), this is my first attempt to make something more serious and on top of that learning a new framework along the way.

Of course there are many things that can be improved, but I only ask you to have mercy.

Thank you so much!
