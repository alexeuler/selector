require_relative "models/crawler/post"
require 'celluloid'
require 'forwardable'

module Selector
  class Features
    DELAY = 600
    include Celluloid

    def initialize(args = {})
      @features = args[:features]
    end

    def start
      loop do
        sleep(DELAY)
        update
      end
    end

    def update
      max_id = @features.count > 0 ? @features.keys.max : 0
      posts = Models::Crawler::Base.connection.execute("select * from posts where id > #{max_id}")
      result = {}
      posts.each { |post| result[post['id'].to_i] = Models::Crawler::Post.to_feature(post)}
      @features.merge! result
      result
    end
  end
end
