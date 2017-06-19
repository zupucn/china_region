module ChinaRegion
  module ORM
    module Memory
      # The Region model containing
      # details about recorded region.
      class Region
        @@regions_index = Set.new
        @@regions = {}

        attr_accessor :name, :code

        def initialize(code:, name:)
          @code = Match.short_code code
          @name = name
        end

        def self.create(code:, name:)
          new(code: code, name: name).save
        end

        def self.get(code)
          name = @@regions[Match.short_code(code)]
          return nil if name.nil?
          new(code: code, name: name)
        end

        def save
          if ChinaRegion::Match.match? @code
            @@regions[@code] = @name
            @@regions_index.add @code
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
            [].tap do |result|
              clone_regions_index = @@regions_index.clone
              clone_regions_index.select! do |index_code|
                /^#{code}\d{#{diff}}$/ =~ index_code
              end
              clone_regions_index.each do |index_code|
                result << self.class.new(code: index_code, name: @@regions[index_code])
              end
            end
          end
        end

        %w(province city district street community).each do |method_name|
          define_singleton_method method_name.pluralize do
            type = Type.by_name(method_name)
            [].tap do |result|
              clone_regions_index = @@regions_index.clone
              clone_regions_index.select! do |code|
                /^\d{#{type.number_count}}$/ =~ code
              end
              clone_regions_index.each do |code|
                result << new(code: code, name: @@regions[code])
              end
            end
          end
        end

        def self.init_data
          require "csv"
          client.pipelined do
            CSV.foreach(File.join(ChinaRegion.root,"data","db.csv"), headers: true, encoding: "utf-8") do |row|
              short_code = Match.short_code(row['code'])
              @@regions[short_code] = row['name']
              @@regions_index.add(short_code)
            end
          end
        end
      end
    end
  end
end
