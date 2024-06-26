# frozen_string_literal: true

module Fintech
  module OrderCommissions
    module Infrastructure
      class PostgresOrderCommissionRepository < Shared::Infrastructure::PostgresRepository
        def all
          order_commissions = rom.relations[:order_commissions].to_a

          order_commissions.map { |order_commission| Domain::OrderCommissionEntity.from_primitives(order_commission) }
        end

        def create(attributes)
          db.transaction do
            rom.relations[:order_commissions].insert(attributes)
          end
        end

        def exists?(attributes)
          rom.relations[:order_commissions].exist?(attributes)
        end

        def monthly_amount(merchant_id:, date:)
          result = db[
            <<~SQL
              SELECT SUM(oc.amount) AS monthly_amount
              FROM order_commissions oc
              JOIN orders o
              ON o.id = oc.order_id
              WHERE o.merchant_id = '#{merchant_id}'
              AND DATE(o.created_at) >= DATE_TRUNC('month', DATE('#{date}'))
              AND DATE(o.created_at) < (DATE_TRUNC('month', DATE('#{date}')) + INTERVAL '1 month')
            SQL
          ]

          result.to_a[0][:monthly_amount] || 0.0
        end
      end
    end
  end
end
