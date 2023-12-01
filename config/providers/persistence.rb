# frozen_string_literal: true

Hanami.app.register_provider :persistence, namespace: true do
  prepare do
    require "rom"

    config = ROM::Configuration.new(:sql, target["settings"].database_url)

    register "config", config
    register "db", config.gateways[:default].connection
  end

  start do
    config = target["persistence.config"]
    config.register_relation(Fintech::Merchants::Infrastructure::MerchantsRelation)
    config.register_relation(Fintech::Orders::Infrastructure::OrdersRelation)
    config.register_relation(Fintech::Disbursements::Infrastructure::DisbursementsRelation)
    config.register_relation(Fintech::OrderCommissions::Infrastructure::OrderCommissionsRelation)

    register "rom", ROM.container(config)
  end
end
