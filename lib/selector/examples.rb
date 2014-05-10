require_relative "models/crawler/post"
require 'celluloid'
require 'forwardable'

module Selector
  class Examples
    DELAY = 600
    include Celluloid

    def initialize(args = {})
      @examples = args[:examples]
    end

    def start
      loop do
        sleep(DELAY)
        update
      end
    end

    def update
      max_id = @examples.count > 0 ? @examples.keys.max : 0
      posts = Models::Crawler::Base.connection.execute("select * from posts where id > #{max_id}")
      result = {}
      posts.each { |post| result[post['id'].to_i] = Models::Crawler::Post.to_example(post)}
      @examples.merge! result
      result
    end
  end
end
