require_relative "svm"

module Selector

  class Trainer
    # likes schema:
    # likes:user_id: zset(post_id:like_value, timestamp)

    DISCARD_LIKES_COUNT = 10 #because these are set to 0 by default and w8s for votes
    MAX_NEW_POSTS = 1000
    def initialize(args={})
      @redis = args[:redis]
      @features_collection = args[:features_collection]
    end

    def train(user_id)
      ids, labels = [], []
      get_likes(user_id).each do |pair|
        ids << pair[0]
        labels << pair[1]
      end
      features = get_features(ids)
      @svm = Svm.new user_id:user_id
      @svm.train(labels,features)
      @svm.save
      ids = get_top
      @redis.ltrim "posts:best:#{user_id}", -1, 0
      @redis.rpush "posts:best:#{user_id}", ids
    end

    def get_likes(user_id)
      likes = @redis.zrange("likes:#{user_id}", DISCARD_LIKES_COUNT, -1)
      likes.map do |like|
        like.split(":").map(&:to_i)
      end
    end

    def get_features(ids)
      ids.map {|id| @features_collection[id]}
    end

    def get_top
      result = []
      @features_collection.each_pair do |id, feature|
        label_and_prob = @svm.predict_probability(feature)
        result.push([id, label_and_prob[:prob]]) if label_and_prob[:label] == 1
      end
      result.sort {|a,b| b[1] <=> a[1]}
      result.map! {|x| x[0]}
      result.first(MAX_NEW_POSTS)
    end

  end
end