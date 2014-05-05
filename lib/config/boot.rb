require_relative "helpers"
require_relative "config"
require 'redis'

App.features = Features.new
App.features.async.start
App.redis = Redis.new(:host => App.config.db.front.host , :port => App.config.db.front.port,
                      :db => App.config.db.front.name)
App.redis.auth(App.config.db.front.password)
