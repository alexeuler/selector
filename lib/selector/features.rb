require_relative "models/crawler/post"
require 'celluloid'
require 'forwardable'

module Selector
  class Features
    DELAY = 1
    include Celluloid
    extend Forwardable
    def_delegators :@features, :[], :[]=, :first, :last, :count, :length, :each, :map, :map!

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
      posts = Base.connection.execute("select * from posts where id > #{max_id}")#Post.where("id > ?", max_id).to_a
      result = posts.map do |post|
        tuple = [post['id'].to_i]
        tuple += Post.to_feature(post)
        tuple
      end
      @features += result
      result
    end
  end
end
