require 'benchmark'
module ChinaRegion
  module ORM
    module Memory
      # The Region model containing
      # details about recorded region.
      class Region
        @@regions_index = []
        @@regions = {}

        attr_accessor :name, :code

        def initialize(code:, name:)
          @code = code
          @name = name
        end

        def self.create(code:, name:)
          new(code: code, name: name).save
        end

        def self.get(code)
          name = @@regions[code]
          return nil if name.nil?
          new(code: code, name: name)
        end

        def save
          if ChinaRegion::Match.match? @code
            @@regions[@code] = @name
            @@regions_index.push @code
            self
          else
            false
          end
        end

        %w(city district street community).each do |method_name|
          define_method method_name.pluralize do
            target_type = Type.by_name(method_name)
            return [] if type < target_type
            diff = target_type.number_count - type.number_count
            regex = /^#{code}\d{#{diff}}$/
            [].tap do |result|
              @@regions_index.grep(regex) do |index_code|
                result << self.class.new(code: index_code, name: @@regions[index_code])
              end
            end
          end
        end

        %w(province city district street community).each do |method_name|
          define_singleton_method method_name.pluralize do
            type = Type.by_name(method_name)
            clone_regions_index = @@regions_index
            regex = /^\d{#{type.number_count}}$/
            [].tap do |result|
              clone_regions_index.grep(regex) do |index_code|
                result << new(code: index_code, name: @@regions[index_code])
              end
            end
          end
        end

        def self.clear
          @@regions.clear
          @@regions_index.clear
        end

        def self.count
          @@regions.size
        end

        def self.init_db(*)
          require "csv"
          CSV.foreach(File.join(ChinaRegion.root,"data","db.csv"), headers: true, encoding: "utf-8") do |row|
            code = row['code']
            @@regions[code] = row['name']
            @@regions_index.push(code)
          end
        end
      end
    end
  end
end
