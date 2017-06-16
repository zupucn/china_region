require 'rails/generators/named_base'

module ChinaRegion
  # A generator module with Activity table schema.
  module Generators
    # A base module
    module Base
      # Get path for migration template
      def source_root
        @_china_region_source_root ||= File.expand_path(File.join('../china_region', generator_name, 'templates'), __FILE__)
      end
    end
  end
end
