module ChinaRegion
  module Query
    extend ActiveSupport::Concern

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
