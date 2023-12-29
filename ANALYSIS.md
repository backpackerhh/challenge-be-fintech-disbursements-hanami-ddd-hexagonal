# Challenge analysis

Implement the process of paying merchants

Automate the calculation of merchants' disbursements payouts and COMPANY commisions

## Requirements

* Orders must be paid only once
* Each disbursement has a unique alphanumerical `reference`
* Orders, amounts, and fees included in disbursements must be easily identifiable for reporting purposes
* Disbursements calculation process must be completed for all merchants by 8:00 UTC daily (cron task at 7:00 UTC maybe)
* Merchants can be disbursed daily or weekly:
  * If weekly, will be made the same weekday as their `live_on` attribute
* Disbursements groups all orders for a merchant in a given day or week
* For each order in a disbursement, COMPANY takes a commission:
  * `1.00 %` fee for orders with an amount strictly smaller than `50 €`
  * `0.95 %` fee for orders with an amount between `50 €` and `300 €`
  * `0.85 %` fee for orders with an amount of `300 €` or more
* Operations with money should round up to two decimals
* First disbursement of each month ensure the `minimum_monthly_fee` for the previous month was reached for each merchant:
  * When a merchant generates less than the minimum, the amount left up that minimum is charged -> `monthly_fee` (only calculated and stored, but not used)
* Include report as table in README.md with aggregations for each year

## CSVs

### Merchants

```csv
id;reference;email;live_on;disbursement_frequency;minimum_monthly_fee
86312006-4d7e-45c4-9c28-788f4aa68a62;padberg_group;info@padberg-group.com;2023-02-01;DAILY;0.0
d1649242-a612-46ba-82d8-225542bb9576;deckow_gibson;info@deckow-gibson.com;2022-12-14;DAILY;0.0
a616488f-c8b2-45dd-b29f-364d12a20238;romaguera_and_sons;info@romaguera-and-sons.com;2022-12-10;DAILY;0.0
9b6d2b8a-f06c-4298-8f27-f33545eb5899;rosenbaum_parisian;info@rosenbaum-parisian.com;2022-11-09;WEEKLY;15.0
fa834b62-f143-4805-a2c7-e085eb608e2c;sanford_group;info@sanford-group.com;2022-12-06;DAILY;30.0
```

### Orders

```csv
id;merchant_reference;amount;created_at
e653f3e14bc4;padberg_group;102.29;2023-02-01
20b674c93ea6;padberg_group;433.21;2023-02-01
0b73fb1d3332;padberg_group;194.37;2023-02-01
9164f0688190;padberg_group;371.33;2023-02-01
04e9b88fe8c7;padberg_group;280.21;2023-02-01
8592e30e09bc;deckow_gibson;377.65;2022-12-15
9f692f409f06;deckow_gibson;138.49;2022-12-15
08cdf6afd459;deckow_gibson;213.3;2022-12-17
403f622ccafb;romaguera_and_sons;462.34;2022-12-10
fddd6aaa66fe;romaguera_and_sons;302.01;2022-12-11
79f899d97726;rosenbaum_parisian;78.13;2022-11-12
eb68acd1182c;rosenbaum_parisian;43.17;2022-11-12
fd44141e7625;rosenbaum_parisian;45.61;2022-11-12
01ed897e5493;rosenbaum_parisian;97.57;2022-11-12
```

## Report

Include following data:

* Year
* Number of disbursements
* Amount disbursed to merchants
* Amount of order fees
* Number of monthly fees charged (From minimum monthly fee)
* Amount of monthly fee charged (From minimum monthly fee)

## Notes

* What does it mean that amounts and fees must have an identifier?
* Check an order was not already paid
* Calculate and store disbursements given any date. If no date is given, then use the day before
* Create a PR in GitHub when code is ready well detailed
* Document each commit as it was production code
* Log as much as possible
* Careful with money calculations

## Tech

* Docker + docker-compose
* Makefile
* Hanami
* Ruby 3.2.2
* DDD + Hexagonal Architecture
* Postgres
* Sidekiq (Redis as dependency)
* Cron

## Relationships

* A merchant has many orders
* A merchant has many disbursements
* A merchant has many monthly commission fees
* A disbursement has many orders
* An order has one commission fee

## DDD

### Use cases

* Import merchants (done)
* Import orders (done)
* Calculate disbursements (merchants with daily frequency or same disbursement weekday) (in progress)
  * Calculate commision fees -> each order in a disbursement
  * Calculate monthly commission fee -> only first disbursement of the month
  * Update all orders with disbursement_id after disbursement is created -> database callback?
* Generate yearly report

### Entities

* Merchant
  * id -> uuid
  * email
  * reference -> unique
  * disbursement_frequency -> enum(daily, weekly)
  * live_on
  * minimum_monthly_fee
  * disbursement_weekday -> calculated directly in a query
  * created_at -> datetime
* Order
  * id -> uuid
  * merchant_id -> uuid, fk
  * disbursement_id -> uuid, fk, null
  * amount
  * created_at -> datetime
  * disbursed? -> method, disbursement_id is not null
* OrderComission
  * id -> uuid
  * order_id -> uuid, fk
  * order_amount -> denormalized
  * amount -> decimal
  * fee -> decimal
  * created_at -> datetime
* Disbursement
  * id -> uuid
  * merchant_id -> uuid, fk
  * reference -> unique
  * amount -> sum orders' amounts - commissions' amount
  * commissions_amount -> sum orders' commissions
  * order_ids -> denormalized, array
  * created_at -> datetime
  * first_payment_of_month? -> method
* MonthlyFee
  * id -> uuid
  * merchant_id -> uuid, fk
  * created_at -> datetime
  * amount -> decimal
  * month -> string

## Testing

### Acceptance tests

Rake task -> job -> use case -> production repository implementation

* Create CSV with a limited set of merchants to import
* The job will receive the path to the file to be imported
* The job should run synchronously -> inline
* Check the expected merchants were created

### Integration tests

Production repository implementation

* The repository should save a merchant
* The absence of failure is the confirmation that the code works
* Add to README that detail and the necessity of adding another method to search for a merchant to know 100% sure the code worked

### Unit tests

Job configuration

Use case -> test repository implementation

* The repository should save a merchant (in memory)
* Test all corner/edge cases

### Object mothers

* Include them as wrappers of factories

## Disbursements

* Cron (07:00am):
  * generate disbursements
    * today disbursable merchants
      * orders without disbursement
        * group by day -> frequency daily
        * group by week -> frequency weekly
      * publish job for each group
        * create disbursement
          * store the sum of all order amounts
          * store the sum of all order commissions
          * store all order IDs included
          * publish event
            * first disbursement of the month
              * create a new monthly commission fee record, only when fee is greater than 0
              * calculate and store it only
            * update orders' disbursement_id column (replace db trigger with domain event)
