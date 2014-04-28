module Selector
  module Models
    class CrawlerBase < ActiveRecord::Base
      self.abstract_class = true
      establish_connection(
          adapter: App.config.db.crawler.adapter,
          host: App.config.db.crawler.host,
          port: App.config.db.crawler.port,
          database: App.config.db.crawler.name,
          username: App.config.db.crawler.user,
          password: App.config.db.crawler.password,
          reaping_frequency: 10,
          pool: 5
      )
    end
  end
end