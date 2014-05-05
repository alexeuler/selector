require_relative "svm"
require 'redis'

module Selector
  class Trainer
    def initialize(args={})
      @redis = args[:redis]
    end

    def train(user_id)
      get_likes
      get_features
      train
      predict
      write_to_redis
    end


  end
end