# frozen_string_literal: true

module Fintech
  module Orders
    module Infrastructure
      class PostgresOrderRepository < Shared::Infrastructure::PostgresRepository
        def all
          orders = rom.relations[:orders].to_a

          orders.map { |order| Domain::OrderEntity.from_primitives(order) }
        end

        def create(attributes)
          db.transaction do
            rom.relations[:orders].insert(attributes)
          end
        end

        def find_by_id(id)
          order = rom.relations[:orders].by_pk(id).first

          if order.nil?
            raise Domain::OrderNotFoundError, id
          end

          Domain::OrderEntity.from_primitives(order)
        end

        def group(grouping_type, merchant_id)
          case grouping_type.downcase
          when "daily"
            db[
              <<~SQL
                SELECT
                  DATE(o.created_at) AS start_date,
                  DATE(o.created_at) AS end_date,
                  ARRAY_AGG(o.id) AS order_ids,
                  SUM(o.amount) AS amount,
                  SUM(oc.amount) as commissions_amount
                FROM orders o
                JOIN order_commissions oc
                ON o.id = oc.order_id
                WHERE o.merchant_id = '#{merchant_id}'
                AND o.disbursement_id IS NULL
                AND DATE(o.created_at) < DATE('#{Date.today}')
                GROUP BY DATE(o.created_at)
                ORDER BY start_date ASC;
              SQL
            ].all
          when "weekly"
            db[
              <<~SQL
                SELECT
                  DATE(DATE_TRUNC('week', o.created_at)) AS start_date,
                  DATE(DATE_TRUNC('week', o.created_at) + INTERVAL '6 days') AS end_date,
                  ARRAY_AGG(o.id) AS order_ids,
                  SUM(o.amount) AS amount,
                  SUM(oc.amount) as commissions_amount
                FROM orders o
                JOIN order_commissions oc
                ON o.id = oc.order_id
                WHERE o.merchant_id = '#{merchant_id}'
                AND o.disbursement_id IS NULL
                AND DATE_TRUNC('week', o.created_at) < DATE_TRUNC('week', DATE('#{Date.today}'))
                GROUP BY DATE_TRUNC('week', o.created_at)
                ORDER BY start_date ASC;
              SQL
            ].all
          else
            raise Domain::UnsupportedGroupingTypeError, "Supported grouping types: daily, weekly"
          end
        end

        def bulk_update_disbursed(order_ids, disbursement_id)
          db.transaction do
            rom.relations[:orders].where(id: order_ids).update(disbursement_id:)
          end
        end
      end
    end
  end
end
