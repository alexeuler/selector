require 'libsvm'
module Selector
  module Models
    module Featurable

      module ClassMethods
        attr_accessor :feature_lambdas
        attr_reader :feature_names, :feature_ordinals

        def feature_names=(names)
          @feature_names = names.map(&:to_sym)
          @feature_names = feature_ordinals.nil? ? @feature_names : @feature_names - feature_ordinals.keys.map(&:to_sym)
        end

        def feature_ordinals=(ordinals)
          @feature_ordinals = ordinals
          @feature_names = feature_ordinals.nil? ? @feature_names : @feature_names - feature_ordinals.keys.map(&:to_sym)
        end

        def to_example(hash)
          feature_ordinals = self.feature_ordinals
          feature_lambdas = self.feature_lambdas
          feature_names = self.feature_names
          ary = []
          feature_names.each do |name|
            value = hash[name.to_s]
            value = feature_lambdas[name].call(value) if feature_lambdas and feature_lambdas.keys.include?(name)
            ary << (value || 0)
          end
          feature_ordinals.each_pair do |name, states|
            value = hash[name.to_s]
            index = states.index(value)
            vector = Array.new(states.count, 0)
            vector[index] = 1 if index
            ary += vector
          end if feature_ordinals
          ary
        end

      end

      def self.included(base)
        base.extend(ClassMethods)
      end


      def to_example
        self.class.to_example(self.attributes)
      end

    end
  end
end