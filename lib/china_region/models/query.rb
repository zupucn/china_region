module ChinaRegion
  module Query
    extend ActiveSupport::Concern

    def parent
      @parent ||= self.class.get parent_code
    end

    def children
      children_type = Type.all[Type.all.index(self.type)+1]
      return [] unless children_type
      @chilren ||= send(children_type.name.pluralize)
    end

    module ClassMethods
      # get some code's sub regions
      def regions_of(code)
        get(code.to_s).children
      end

      %w(city district street community).each do | region |
        define_method "#{region.pluralize}_of" do | code |
          get(code).send(region.pluralize)
        end
      end
      #
    end
  end
end
