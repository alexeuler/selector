require_relative 'base'
require_relative "../featurable"

module Selector
  module Models
    module Crawler
      class Post < Base
        include Models::Featurable
        self.feature_names = %w(likes_count  likes_age  likes_share
          closed_profiles_share reposts_count text
          comments_count vk_id attachment_type)
        self.feature_lambdas = {
            likes_count: lambda {|x| x.to_i},
            likes_age: lambda {|x| x.to_i},
            likes_share: lambda {|x| x.to_f},
            closed_profiles_share: lambda {|x| x.to_f},
            reposts_count: lambda {|x| x.to_i},
            text: lambda { |x| x.nil? ? 0 : x.length },
            comments_count: lambda {|x| x.to_i},
            vk_id: lambda { |x| Math.log x.to_i }
        }
        self.feature_ordinals = {
            attachment_type: [0, "graffiti", "audio", "link", "video", "poll", "doc", "photo", "note", "album"]
        }

      end
    end
  end
end