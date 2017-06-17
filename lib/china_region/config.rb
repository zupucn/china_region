require 'singleton'

module ChinaRegion
  # Class used to initialize configuration object.
  class Config
    include ::Singleton
    attr_accessor :table_name, :redis, :memcached

    @@orm = :active_record

    def initialize
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
      @@orm = b.orm unless b.orm.nil?
      instance
      instance.instance_variable_set(:@enabled,    b.enabled)   unless  b.enabled.nil?
    end

    # Set the ORM for use by ChinaRegion.
    def self.orm(orm = nil)
      @@orm = (orm ? orm.to_sym : false) || @@orm
    end

    # alias for {#orm}
    # @see #orm
    def self.orm=(orm = nil)
      orm(orm)
    end

    # instance version of {Config#orm}
    # @see Config#orm
    def orm(orm=nil)
      self.class.orm(orm)
    end

    # Provides simple DSL for the config block.
    class Block
      attr_reader :orm, :enabled, :table_name
      # @see Config#orm
      def orm(orm = nil)
        @orm = (orm ? orm.to_sym : false) || @orm
      end
      # Sets the redis
      # for the model
      def redis(redis = nil)
        ChinaRegion.config.redis = redis
      end

      # Sets the table_name
      # for the model
      def table_name(name = nil)
        ChinaRegion.config.table_name = name
      end
    end
  end
end
