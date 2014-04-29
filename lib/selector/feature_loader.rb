require_relative "models/crawler/post"

module Selector
  class FeatureLoader
    def self.update(data)
      data ||={}
      max = data.keys.last || 0
      posts = Post.where("id > ?", max)
      result = {}
      posts.each do |post|
        result.merge! post.to_feature
      end
      data.merge! result
      result
    end
  end
end
