# frozen_string_literal: true

Hanami.app.register_provider(:redis) do
  prepare do
    require "redis"
  end

  start do
    client = Redis.new(url: target["settings"].redis_url)

    register "redis", client
  end
end
