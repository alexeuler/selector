require 'ostruct'

class App
  class << self
    attr_accessor :config, :redis, :features, :root
  end
end


App.root = File.expand_path("../..",
                            File.dirname(__FILE__))

App.config = OpenStruct.new

App.config.db = OpenStruct.new
App.config.db.crawler = OpenStruct.new
App.config.db.crawler.user = ENV['CRAWLER_DB_USER']
App.config.db.crawler.password = ENV['CRAWLER_DB_PASS']
App.config.db.crawler.name = ENV['CRAWLER_DB_NAME']
App.config.db.crawler.host = ENV['CRAWLER_DB_HOST']
App.config.db.crawler.port = ENV['CRAWLER_DB_PORT']
App.config.db.crawler.adapter = "postgresql"

App.config.db.front = OpenStruct.new
App.config.db.front.host = ENV['FRONT_DB_HOST']
App.config.db.front.port = ENV['FRONT_DB_PORT']
App.config.db.front.password = ENV['FRONT_DB_PASS']
App.config.db.front.name = ENV['FRONT_DB_NAME']

App.config.rack = OpenStruct.new
App.config.rack.port = ENV['SELECTOR_PORT']