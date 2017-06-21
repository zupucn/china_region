module ChinaRegion
  module ORM
    module ActiveRecord
      # The Region model containing
      # details about recorded region.
      class Region < ::ActiveRecord::Base
        before_save :compact_code

        self.table_name = ChinaRegion.config.table_name

        def self.get(code)
          find_by_code(Match.short_code(code))
        end

        %w(city district street community).each do | name |
          define_method name.pluralize do
            target_type = Type.by_name(name)
            return [] if type < target_type
            diff = target_type.number_count - type.number_count
            self.class.where("code like ?", "#{code}#{'_'*diff}")
          end
        end

        %w(province city district street community).each do | method_name |
          define_singleton_method method_name.pluralize do
            type = Type.by_name(method_name)
            where("code like ?", "#{'_'*type.number_count}")
          end
        end

        def self.init_db(batch_size = 500)
          require "csv"
          inserts = []
          CSV.foreach(File.join(ChinaRegion.root,"data","db.csv"), headers: true, encoding: "utf-8").with_index do |row, i|
            inserts.push "('#{Match.short_code(row['code'])}','#{row['name']}')"
            if (i % batch_size.to_i == 0)
              import_data(inserts)
              inserts.clear
            end
          end
          if inserts.any?
            import_data(inserts)
          end
        end

        def self.import_data(inserts)
          sql = "INSERT INTO #{ChinaRegion.config.table_name} (code, name) VALUES #{inserts.join(",")}"
          connection.execute sql
        end

        private
          def compact_code
            self.code = Match.short_code(code)
          end
      end
    end
  end
end
