module ChinaRegion
  module ORM
    module Memcached
      # The Region model containing
      # details about recorded region.
      class Region
        def initialize(code, name)
          @code = code
          @name = name
        end

        def self.client
          ChinaRegion.config.memcached
        end

        def self.create(code, name)
          self.class.new(code, name).save
        end

        def self.get(code)
          name = Region.client.get(code)
          return nil if name.nil?
          self.class.new(code, name)
        end

        def save
          if ChinaRegion::Match.match? @code
            Region.client.set(@code, @name)
            self
          else
            false
          end
        end

        %w(city district street community).each do |name|
          define_method name.pluralize do
          end
        end

        private
        def relationship
          
        end
      end
    end
  end
end
