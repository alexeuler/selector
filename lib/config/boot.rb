require_relative "helpers"
require_relative "config"
require 'redis'
require 'active_record'
Helpers.require_dir(File.expand_path("../selector/models/crawler",
                                     File.dirname(__FILE__)))
require_relative '../selector/examples'
require_relative '../selector/trainer'

App.examples = {}
fetcher = Selector::Examples.new(examples: App.examples)
puts "Loading features..."
fetcher.update
puts "Done"
fetcher.async.start
App.redis = Redis.new(:host => App.config.db.front.host , :port => App.config.db.front.port,
                      :db => App.config.db.front.name)

