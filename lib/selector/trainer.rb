require_relative "svm"
require 'ruby-prof'

module Selector

  class Trainer
    # likes schema:
    # likes:user_id: hash(post_id:like_value)

    DISCARD_LIKES_COUNT = 10 #because these are set to 0 by default and w8s for votes
    MAX_NEW_POSTS = 1000

    def initialize(args={})
      @redis = args[:redis]
      @examples_collection = args[:examples_collection]
    end

    def train(user_id)
      likes_hash = get_likes(user_id)
      train_ids, labels = likes_hash.keys.map(&:to_i), likes_hash.values.map(&:to_i)
      examples = get_examples(train_ids)
      @svm = Svm.new user_id: user_id
      @svm.train(labels, examples)
      @svm.save
      top_ids = get_top(except: train_ids)
      @redis.del "posts:best:#{user_id}"
      @redis.rpush "posts:best:#{user_id}", top_ids unless top_ids.empty?
    end

    def get_likes(user_id)
      @redis.hgetall("likes:#{user_id}")
    end

    def get_examples(ids)
      ids.map { |id| @examples_collection[id] }
    end

    def get_top(args = {})
      except_ids = args[:except] || []
      #The hash is for the optimization of lookup speed
      except_hash = {}
      except_ids.each {|id| except_hash[id]=true}
      result = []
      @examples_collection.each_pair do |id, example|
        next if except_hash[id]
        label_and_prob = @svm.predict_probability(example)
        result.push([id, label_and_prob[:prob]]) if label_and_prob[:label] == 1
      end
      result.sort! { |a, b| b[1] <=> a[1] }
      result.map! { |x| x[0] }
      result.first(MAX_NEW_POSTS)
    end

  end
end