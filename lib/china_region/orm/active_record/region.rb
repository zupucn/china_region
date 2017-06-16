module ChinaRegion
  module ORM
    module ActiveRecord
      # The Region model containing
      # details about recorded region.
      class Region < ::ActiveRecord::Base
        self.table_name = ChinaRegion.config.table_name

        def parent
          @parent ||= Region.find_by_code parent_code
        end

        def children
          children_type = Type.all[Type.index_of(self.type)+1]
          return [] unless children_type
          send(children_type.name.pluralize)
        end

        def get(code)
          self.class.find_by_code code
        end

        %w(city district street community).each do | name |
          define_method name.pluralize do
            target_type = Type.by_name(name)
            return [] if type < target_type
            diff = target_type.number_count - type.number_count
            self.class.where.not(id: id).where("code like ?", "#{short_code}#{'_'*diff}".ljust(6,'0'))
          end
        end
      end
    end
  end
end
