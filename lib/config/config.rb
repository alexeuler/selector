require 'ostruct'

module App
  class << self
    attr_accessor :config
  end
end

App.config = OpenStruct.new

App.config.db = OpenStruct.new
App.config.db.user = ENV['PG_USER']
App.config.db.password = ENV['PG_PASS']
App.config.db.name = "crawler"
App.config.db.host = "localhost"
App.config.db.adapter = "postgresql"

App.config.tokens = OpenStruct.new
App.config.tokens.user = ENV["TOKENS_USER"]
App.config.tokens.password = ENV["TOKENS_PASS"]
App.config.tokens.port = 9292
