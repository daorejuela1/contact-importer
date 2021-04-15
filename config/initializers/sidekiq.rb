require 'sidekiq'
config.redis = { url: ENV['REDIS_URL']  }
