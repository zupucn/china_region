require 'singleton'

module ChinaRegion
  # Class used to initialize configuration object.
  class Config
    include ::Singleton
    attr_accessor :orm, :table_name, :redis, :memcached

    def initialize
      @orm = :active_record
      @table_name = "china_regions"
    end

    # Evaluates given block to provide DSL configuration.
    # @example Initializer for Rails
    #   ChinaRegion::Config.set do
    #     orm :redis
    #     table_name "regions"
    #   end
    def self.set &block
      b = Block.new
      b.instance_eval(&block)
      %i(orm table_name redis).each do |method|
        instance.send("#{method}=", b.send(method))
      end
      instance
    end

    # Provides simple DSL for the config block.
    class Block
      attr_reader :orm, :redis, :table_name
      # @see Config#orm
      def orm(orm = nil)
        @orm = (orm ? orm.to_sym : false) || @orm
      end

      %i(redis table_name).each do | method |
        define_method method do | arg = nil|
          instance_variable_set("@#{method}", arg || instance_variable_get("@#{method}"))
        end
      end
    end
  end
end
