require 'ostruct'

module App
  class << self
    attr_accessor :config
  end
end

App.config = OpenStruct.new

App.config.db = OpenStruct.new
App.config.db.crawler = OpenStruct.new
App.config.db.crawler.user = ENV['CRAWLER_DB_USER']
App.config.db.crawler.password = ENV['CRAWLER_DB_PASS']
App.config.db.crawler.name = ENV['CRAWLER_DB_NAME']
App.config.db.crawler.host = ENV['CRAWLER_DB_HOST']
App.config.db.crawler.port = ENV['CRAWLER_DB_PORT']
App.config.db.adapter = "postgresql"