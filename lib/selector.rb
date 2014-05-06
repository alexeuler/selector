require_relative "selector/trainer"

module Selector

  def self.select(user_id)
    trainer = Trainer.new(redis: App.redis, features_collection: App.features)
    trainer.train(user_id)
  end

end