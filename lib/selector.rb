require_relative "selector/trainer"

module Selector

  MINIMUM_TRAINING_TIME_INTERVAL = 10 #in seconds

  def self.select(user_id)
    #If this user's model is already being trained - reject
    time_lock = App.redis.hget("lock:train", user_id).to_i
    return if time_lock != nil and
        Time.now.to_i - time_lock < MINIMUM_TRAINING_TIME_INTERVAL
    App.redis.hset("lock:train", user_id, Time.now.to_i)
    trainer = Trainer.new(redis: App.redis, features_collection: App.features)
    trainer.train(user_id)
  end

end