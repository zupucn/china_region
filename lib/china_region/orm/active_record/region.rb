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

        private
          def compact_code
            self.code = Match.short_code(code)
          end
      end
    end
  end
end
