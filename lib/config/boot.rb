require_relative "helpers"
require_relative "config"
require 'redis'
require 'active_record'
Helpers.require_dir(File.expand_path("../selector/models/crawler",
                                     File.dirname(__FILE__)))
require_relative '../selector/features'
require_relative '../selector/trainer'

App.features = {}
fetcher = Selector::Features.new(features: App.features)
puts "Loading features..."
fetcher.update
puts "Done"
fetcher.async.start
App.redis = Redis.new(:host => App.config.db.front.host , :port => App.config.db.front.port,
                      :db => App.config.db.front.name)
App.redis.auth(App.config.db.front.password)

