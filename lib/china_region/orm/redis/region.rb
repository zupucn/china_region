module ChinaRegion
  module ORM
    module Redis
      class Region
        extend ActiveModel::Callbacks
        define_model_callbacks :save
        before_save :compact_code
        HASH_KEY = "china_region/regions"

        attr_accessor :name, :code

        def initialize(name:, code:)
          @name = name
          @code = Match.short_code(code)
        end

        def self.get(code)
          name = client.hget(HASH_KEY, Match.short_code(code))
          return nil unless name
          new(name: name, code: code)
        end

        %w(city district street community).each do | method_name |
          define_method method_name.pluralize do
            target_type = Type.by_name(method_name)
            return [] if type < target_type
            diff = target_type.number_count - type.number_count
            [].tap do | result |
              client.hscan_each HASH_KEY, match: "#{code}#{'?'*diff}" do | code, name |
                result << self.class.new(name: name, code: code)
              end
            end
          end
        end

        %w(province city district street community).each do | method_name |
          define_singleton_method method_name.pluralize do
            type = Type.by_name(method_name)
            [].tap do | result |
              client.hscan_each HASH_KEY, match: "#{'?'*type.number_count}" do | code, name |
                result << new(name: name, code: code)
              end
            end
          end
        end

        def self.create(name:,code:)
          new(name: name,code: code).save
        end

        def save
          tap do
            run_callbacks :save do
              client.hset(HASH_KEY, @code, @name)
            end
          end
        end

        def client
          self.class.client
        end

        def self.client
          ChinaRegion.config.redis
        end

        def self.db_exists?
          client.exists(HASH_KEY)
        end

        def self.count
          client.hlen HASH_KEY
        end

        def self.init_db(*args)
          require "csv"
          client.pipelined do
            CSV.foreach(File.join(ChinaRegion.root,"data","db.csv"), headers: true, encoding: "utf-8") do |row|
               client.hset(HASH_KEY, Match.short_code(row['code']), row['name'])
            end
          end
        end

        private
          def compact_code
            self.code = Match.short_code(code)
          end
      end
    end
  end
end
