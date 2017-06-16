require 'active_support'

module ChinaRegion
  extend ActiveSupport::Autoload

  autoload :Query,      'china_region/models/query'
  autoload :Type,       'china_region/models/type'
  autoload :Region,     'china_region/models/region'

  autoload :Match
  autoload :Config
  autoload :VERSION

  # Returns ChinaRegion's configuration object.
  def self.config
    @@config ||= ChinaRegion::Config.instance
  end

  def self.inherit_orm(model="Region")
    orm = ChinaRegion.config.orm
    require "china_region/orm/#{orm.to_s}"
    "ChinaRegion::ORM::#{orm.to_s.camelize}::#{model}".constantize
  end
end
