module ChinaRegion
  module ORM
    module Redis
      class Region
        HASH_KEY = "china_region/regions"

        attr_accessor :name, :code

        def initialize(name:, code:)
          @name = name
          @code = code
        end

        def self.get(code)
          name = client.hget(HASH_KEY, code)
          return nil unless name
          new(name: name, code: code)
        end

        %w(city district street community).each do | method_name |
          define_method method_name.pluralize do
            target_type = Type.by_name(method_name)
            return [] if type < target_type
            diff = target_type.number_count - type.number_count
            [].tap do | result |
              client.hscan_each HASH_KEY, match: "#{short_code}#{'?'*diff}".ljust(6,'0') do | code, name |
                result << self.class.new(name: name, code: code) unless code == self.code
              end
            end
          end
        end

        def ==(other)
          code == other.code
        end

        def self.create(name:,code:)
          new(name: name,code: code).save
        end

        def save
          tap do
            client.hset(HASH_KEY, @code, @name)
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


        def self.init_db
          require "csv"
          client.pipelined do
            CSV.foreach(File.join(ChinaRegion.root,"data","db.csv"), headers: true, encoding: "utf-8") do |row|
              client.hset(HASH_KEY, row['code'], row['name'])
            end
          end
        end
      end
    end
  end
end
