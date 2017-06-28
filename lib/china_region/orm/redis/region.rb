module ChinaRegion
  module ORM
    module Redis
      class Region
        extend ActiveModel::Callbacks
        define_model_callbacks :save
    #    before_save :compact_code

        attr_accessor :name, :code

        def initialize(name:, code:)
          @name = name
          @code = code
        end

        def self.get(code)
          return nil if code.blank?
          name = client.hget(region_key(code), code)
          return nil unless name
          new(name: name, code: code)
        end

        %w(city district street community).each do | method_name |
          define_method method_name.pluralize do
            target_type = Type.all[Type.all.index(Type.by_name(method_name))-1]
            return [] if type < target_type
            diff = target_type.number_count - type.number_count
            codes = []
            client.scan_each match: File.join("china_region","#{code}#{'?'*diff}", method_name.pluralize), count: 1000 do | code |
              codes << code
            end
            region_hash = {}
            codes.each do | code |
              region_hash.merge!(client.hgetall(code))
            end

            [].tap do | regions |
              region_hash.each do |code, name|
                regions << self.class.new(name: name, code: code)
              end
            end
          end
        end

        %w(province city district street community).each do | method_name |
          define_singleton_method method_name.pluralize do
            type = Type.by_name(method_name)
            codes = []
            client.scan_each match: File.join("china_region","*",method_name.pluralize), count: 1000 do | code |
              codes << code
            end
            region_hash = {}
            codes.each do | code |
              region_hash.merge! client.hgetall(code)
            end
            [].tap do | regions |
              region_hash.each do |code, name|
                regions << new(name: name, code: code)
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
              client.hset(region_key, @code, @name)
            end
          end
        end

        def client
          self.class.client
        end

        def self.client
          ChinaRegion.config.redis
        end

        def region_key
          self.class.region_key(code)
        end

        def self.region_key(code)
          parent = Match.upper_level(code)
          parent = parent.blank? ? "000000" : parent
          type = Type.by_code(code)
          File.join("china_region", parent, type.name.pluralize)
        end

        def self.count
  #        client.hlen HASH_KEY
        end

        def self.init_db(*)
          require "csv"
          client.pipelined do
            CSV.foreach(File.join(ChinaRegion.root,"data","db.csv"), headers: true, encoding: "utf-8") do |row|
              code = row['code']
              client.hset(region_key(code), code, row['name'])
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
