require_relative "models/crawler/post"
require 'celluloid'
require 'forwardable'

module Selector
  class Features
    DELAY = 1
    include Celluloid
    extend Forwardable
    def_delegators :@features, :[], :[]=

    def initialize
      @features = []
    end

    def start
      loop do
        update
        sleep(DELAY)
      end
    end

    def update
      max_id = @features.count > 0 ? @features.last[0] : 0
      posts = Post.where("id > ?", max_id)
      result = posts.map do |post|
        tuple = [post.id]
        tuple += post.to_feature
        tuple
      end
      @features += result
      result
    end
  end
end
