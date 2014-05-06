require_relative "models/crawler/post"
require 'celluloid'
require 'forwardable'

module Selector
  class Features
    DELAY = 600
    include Celluloid
    extend Forwardable
    def_delegators :@features, :[], :[]=, :count, :length, :each, :map, :map!, :each_key,
                   :each_pair, :each_with_index, :keys, :values

    def initialize
      @features = {}
    end

    def start
      loop do
        update
        sleep(DELAY)
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
